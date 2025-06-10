-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_cart_items_updated_at BEFORE UPDATE ON public.cart_items
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON public.reviews
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_coupons_updated_at BEFORE UPDATE ON public.coupons
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to generate order number
CREATE OR REPLACE FUNCTION public.generate_order_number()
RETURNS TEXT AS $$
DECLARE
  new_number TEXT;
  counter INTEGER;
BEGIN
  -- Get current date in YYYYMMDD format
  new_number := 'AK' || TO_CHAR(NOW(), 'YYYYMMDD');
  
  -- Get count of orders created today
  SELECT COUNT(*) + 1 INTO counter
  FROM public.orders
  WHERE order_number LIKE new_number || '%';
  
  -- Append counter with leading zeros
  new_number := new_number || LPAD(counter::TEXT, 4, '0');
  
  RETURN new_number;
END;
$$ LANGUAGE plpgsql;

-- Function to check product stock
CREATE OR REPLACE FUNCTION public.check_product_stock(
  product_id UUID,
  requested_quantity INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
  available_stock INTEGER;
BEGIN
  SELECT (stock_quantity - reserved_quantity) INTO available_stock
  FROM public.products
  WHERE id = product_id;
  
  RETURN available_stock >= requested_quantity;
END;
$$ LANGUAGE plpgsql;

-- Function to reserve product stock
CREATE OR REPLACE FUNCTION public.reserve_product_stock(
  product_id UUID,
  quantity INTEGER
)
RETURNS BOOLEAN AS $$
BEGIN
  UPDATE public.products
  SET reserved_quantity = reserved_quantity + quantity
  WHERE id = product_id
  AND (stock_quantity - reserved_quantity) >= quantity;
  
  RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Function to release reserved stock
CREATE OR REPLACE FUNCTION public.release_reserved_stock(
  product_id UUID,
  quantity INTEGER
)
RETURNS VOID AS $$
BEGIN
  UPDATE public.products
  SET reserved_quantity = GREATEST(0, reserved_quantity - quantity)
  WHERE id = product_id;
END;
$$ LANGUAGE plpgsql;

-- Function to fulfill order (convert reserved to sold)
CREATE OR REPLACE FUNCTION public.fulfill_order_stock(
  product_id UUID,
  quantity INTEGER
)
RETURNS VOID AS $$
BEGIN
  UPDATE public.products
  SET 
    stock_quantity = stock_quantity - quantity,
    reserved_quantity = GREATEST(0, reserved_quantity - quantity)
  WHERE id = product_id;
END;
$$ LANGUAGE plpgsql;

-- Function to get product rating
CREATE OR REPLACE FUNCTION public.get_product_rating(product_id UUID)
RETURNS TABLE(
  average_rating DECIMAL(3,2),
  total_reviews INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ROUND(AVG(rating)::DECIMAL, 2) as average_rating,
    COUNT(*)::INTEGER as total_reviews
  FROM public.reviews
  WHERE reviews.product_id = get_product_rating.product_id;
END;
$$ LANGUAGE plpgsql;

-- Function to search products
CREATE OR REPLACE FUNCTION public.search_products(
  search_query TEXT,
  category_filter TEXT DEFAULT NULL,
  min_price DECIMAL DEFAULT NULL,
  max_price DECIMAL DEFAULT NULL,
  limit_count INTEGER DEFAULT 20,
  offset_count INTEGER DEFAULT 0
)
RETURNS TABLE(
  id UUID,
  name VARCHAR(255),
  description TEXT,
  price DECIMAL(10,2),
  primary_image TEXT,
  category VARCHAR(100),
  average_rating DECIMAL(3,2),
  total_reviews INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.name,
    p.description,
    p.price,
    p.primary_image,
    p.category,
    COALESCE(r.average_rating, 0) as average_rating,
    COALESCE(r.total_reviews, 0) as total_reviews
  FROM public.products p
  LEFT JOIN (
    SELECT 
      product_id,
      ROUND(AVG(rating)::DECIMAL, 2) as average_rating,
      COUNT(*)::INTEGER as total_reviews
    FROM public.reviews
    GROUP BY product_id
  ) r ON p.id = r.product_id
  WHERE 
    p.is_active = true
    AND (search_query IS NULL OR to_tsvector('english', p.name || ' ' || COALESCE(p.description, '')) @@ plainto_tsquery('english', search_query))
    AND (category_filter IS NULL OR p.category = category_filter)
    AND (min_price IS NULL OR p.price >= min_price)
    AND (max_price IS NULL OR p.price <= max_price)
  ORDER BY 
    CASE WHEN search_query IS NOT NULL THEN ts_rank(to_tsvector('english', p.name || ' ' || COALESCE(p.description, '')), plainto_tsquery('english', search_query)) END DESC,
    p.created_at DESC
  LIMIT limit_count
  OFFSET offset_count;
END;
$$ LANGUAGE plpgsql;
