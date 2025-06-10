-- Insert admin user
INSERT INTO users (email, name, password_hash, role, is_verified) VALUES
('admin@akaal.com', 'Admin User', '$2b$10$rQZ9QmjlhQZ9QmjlhQZ9Qu', 'admin', true),
('demo@akaal.com', 'Demo User', '$2b$10$rQZ9QmjlhQZ9QmjlhQZ9Qu', 'user', true)
ON CONFLICT (email) DO NOTHING;

-- Insert sample products
INSERT INTO products (name, description, details, price, category, sizes, images, primary_image, tags, stock_quantity) VALUES
('Vintage Denim Jacket', 'Classic vintage denim jacket in excellent condition', 'This vintage denim jacket features authentic wear patterns and classic styling. Perfect for layering and adding a retro touch to any outfit.', 89.99, 'Jackets', ARRAY['S', 'M', 'L', 'XL'], ARRAY['/placeholder.svg?height=400&width=400'], '/placeholder.svg?height=400&width=400', ARRAY['vintage', 'denim', 'jacket'], 15),
('Retro Band T-Shirt', 'Authentic vintage band t-shirt', 'Original vintage band merchandise in great condition. Soft cotton fabric with classic band graphics.', 45.00, 'T-Shirts', ARRAY['S', 'M', 'L'], ARRAY['/placeholder.svg?height=400&width=400'], '/placeholder.svg?height=400&width=400', ARRAY['vintage', 'band', 'tshirt'], 8),
('High-Waisted Mom Jeans', 'Classic 90s style mom jeans', 'Comfortable high-waisted jeans with a relaxed fit. Perfect vintage 90s styling.', 65.00, 'Jeans', ARRAY['26', '28', '30', '32'], ARRAY['/placeholder.svg?height=400&width=400'], '/placeholder.svg?height=400&width=400', ARRAY['vintage', 'jeans', '90s'], 12),
('Leather Bomber Jacket', 'Genuine leather bomber jacket', 'High-quality leather bomber jacket with classic styling. Excellent condition with minimal wear.', 150.00, 'Jackets', ARRAY['S', 'M', 'L'], ARRAY['/placeholder.svg?height=400&width=400'], '/placeholder.svg?height=400&width=400', ARRAY['leather', 'bomber', 'jacket'], 5),
('Vintage Sneakers', 'Classic vintage sneakers', 'Authentic vintage sneakers in great condition. Comfortable and stylish.', 75.00, 'Shoes', ARRAY['7', '8', '9', '10', '11'], ARRAY['/placeholder.svg?height=400&width=400'], '/placeholder.svg?height=400&width=400', ARRAY['vintage', 'sneakers', 'shoes'], 10)
ON CONFLICT DO NOTHING;
