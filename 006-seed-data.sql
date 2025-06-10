-- Insert categories
INSERT INTO public.categories (name, slug, description, sort_order) VALUES
('Clothing', 'clothing', 'Vintage and thrift clothing items', 1),
('Accessories', 'accessories', 'Fashion accessories and jewelry', 2),
('Shoes', 'shoes', 'Vintage and pre-owned footwear', 3),
('Bags', 'bags', 'Handbags, backpacks, and luggage', 4),
('Home & Decor', 'home-decor', 'Vintage home decoration items', 5),
('Electronics', 'electronics', 'Refurbished electronics and gadgets', 6)
ON CONFLICT (slug) DO NOTHING;

-- Insert subcategories
INSERT INTO public.categories (name, slug, description, parent_id, sort_order) VALUES
('Jackets', 'jackets', 'Vintage jackets and outerwear', (SELECT id FROM public.categories WHERE slug = 'clothing'), 1),
('T-Shirts', 'tshirts', 'Vintage and band t-shirts', (SELECT id FROM public.categories WHERE slug = 'clothing'), 2),
('Jeans', 'jeans', 'Vintage denim and jeans', (SELECT id FROM public.categories WHERE slug = 'clothing'), 3),
('Dresses', 'dresses', 'Vintage dresses and formal wear', (SELECT id FROM public.categories WHERE slug = 'clothing'), 4),
('Sneakers', 'sneakers', 'Vintage and retro sneakers', (SELECT id FROM public.categories WHERE slug = 'shoes'), 1),
('Boots', 'boots', 'Vintage boots and work shoes', (SELECT id FROM public.categories WHERE slug = 'shoes'), 2)
ON CONFLICT (slug) DO NOTHING;

-- Insert sample products
INSERT INTO public.products (
  name, description, details, price, compare_at_price, category, subcategory, 
  condition, sizes, colors, images, primary_image, tags, sku, stock_quantity, is_featured
) VALUES
(
  'Vintage Levi''s Denim Jacket',
  'Classic vintage Levi''s denim jacket from the 1980s in excellent condition',
  'This authentic vintage Levi''s denim jacket features the classic trucker style with button closure, chest pockets, and adjustable side tabs. Made from heavyweight denim with beautiful fading and wear patterns that give it character. Perfect for layering and adding a retro touch to any outfit.',
  89.99, 120.00, 'Clothing', 'Jackets', 'excellent',
  ARRAY['S', 'M', 'L', 'XL'], ARRAY['Blue', 'Indigo'],
  ARRAY['/placeholder.svg?height=400&width=400&text=Denim+Jacket+Front', '/placeholder.svg?height=400&width=400&text=Denim+Jacket+Back'],
  '/placeholder.svg?height=400&width=400&text=Denim+Jacket+Front',
  ARRAY['vintage', 'levis', 'denim', 'jacket', '1980s'], 'VLJ001', 5, true
),
(
  'Retro Band T-Shirt - The Beatles',
  'Authentic vintage Beatles band t-shirt from the 1990s',
  'Original vintage Beatles merchandise in great condition. Soft cotton fabric with classic band graphics and logo. This shirt has been well-preserved and shows minimal signs of wear. A must-have for any music lover or vintage collector.',
  45.00, 65.00, 'Clothing', 'T-Shirts', 'good',
  ARRAY['S', 'M', 'L'], ARRAY['Black', 'White'],
  ARRAY['/placeholder.svg?height=400&width=400&text=Beatles+Tshirt'],
  '/placeholder.svg?height=400&width=400&text=Beatles+Tshirt',
  ARRAY['vintage', 'band', 'tshirt', 'beatles', 'music'], 'RBT001', 3, true
),
(
  'High-Waisted Mom Jeans',
  'Classic 90s style high-waisted mom jeans',
  'Comfortable high-waisted jeans with a relaxed fit through the hips and tapered legs. Perfect vintage 90s styling with authentic wear and fading. These jeans are versatile and can be dressed up or down for any occasion.',
  65.00, 85.00, 'Clothing', 'Jeans', 'excellent',
  ARRAY['26', '28', '30', '32', '34'], ARRAY['Blue', 'Light Blue'],
  ARRAY['/placeholder.svg?height=400&width=400&text=Mom+Jeans'],
  '/placeholder.svg?height=400&width=400&text=Mom+Jeans',
  ARRAY['vintage', 'jeans', '90s', 'high-waisted', 'mom-jeans'], 'HWJ001', 8, false
),
(
  'Leather Bomber Jacket',
  'Genuine leather bomber jacket in brown',
  'High-quality genuine leather bomber jacket with classic styling. Features ribbed cuffs and hem, front zip closure, and side pockets. The leather has developed a beautiful patina over time. Excellent condition with minimal wear.',
  150.00, 200.00, 'Clothing', 'Jackets', 'excellent',
  ARRAY['S', 'M', 'L'], ARRAY['Brown', 'Black'],
  ARRAY['/placeholder.svg?height=400&width=400&text=Leather+Bomber'],
  '/placeholder.svg?height=400&width=400&text=Leather+Bomber',
  ARRAY['leather', 'bomber', 'jacket', 'vintage'], 'LBJ001', 2, true
),
(
  'Vintage Nike Air Max 90',
  'Classic Nike Air Max 90 sneakers from 1995',
  'Authentic vintage Nike Air Max 90 sneakers in the original colorway. These shoes have been well-maintained and show minimal wear. The Air Max cushioning system is still functional and provides excellent comfort. A true collector''s item.',
  120.00, 180.00, 'Shoes', 'Sneakers', 'good',
  ARRAY['7', '8', '9', '10', '11'], ARRAY['White', 'Grey', 'Red'],
  ARRAY['/placeholder.svg?height=400&width=400&text=Air+Max+90'],
  '/placeholder.svg?height=400&width=400&text=Air+Max+90',
  ARRAY['vintage', 'nike', 'airmax', 'sneakers', '90s'], 'VAM001', 4, true
),
(
  'Vintage Floral Dress',
  '1970s vintage floral midi dress',
  'Beautiful vintage floral midi dress from the 1970s. Features a flattering A-line silhouette, three-quarter sleeves, and a vibrant floral print. Made from lightweight fabric perfect for spring and summer. This dress has been carefully preserved and is in excellent condition.',
  75.00, 95.00, 'Clothing', 'Dresses', 'excellent',
  ARRAY['XS', 'S', 'M'], ARRAY['Floral', 'Multi'],
  ARRAY['/placeholder.svg?height=400&width=400&text=Floral+Dress'],
  '/placeholder.svg?height=400&width=400&text=Floral+Dress',
  ARRAY['vintage', 'dress', '1970s', 'floral', 'midi'], 'VFD001', 6, false
)
ON CONFLICT (sku) DO NOTHING;

-- Insert sample coupons
INSERT INTO public.coupons (code, name, description, type, value, minimum_amount, usage_limit, starts_at, expires_at) VALUES
('WELCOME10', 'Welcome Discount', 'Get 10% off your first order', 'percentage', 10.00, 50.00, 100, NOW(), NOW() + INTERVAL '30 days'),
('FREESHIP', 'Free Shipping', 'Free shipping on orders over $75', 'free_shipping', 0.00, 75.00, NULL, NOW(), NOW() + INTERVAL '60 days'),
('VINTAGE20', 'Vintage Sale', '$20 off vintage items', 'fixed_amount', 20.00, 100.00, 50, NOW(), NOW() + INTERVAL '14 days')
ON CONFLICT (code) DO NOTHING;

-- Create admin user (this will be handled by the auth trigger)
-- The admin user should be created through Supabase Auth UI or API
