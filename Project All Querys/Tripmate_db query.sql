SELECT 
    schemaname,
    relname AS table_name,
    n_live_tup AS estimated_row_count
FROM pg_stat_user_tables
ORDER BY table_name;

SELECT id, username, email, role, created_at FROM users;

SELECT 
    w.id,
    u.username,
    w.title,
    w.target_type,
    w.target_value,
    w.threshold_price,
    w.current_price_estimate,
    w.currency,
    w.active,
    w.created_at
FROM watchlists w
LEFT JOIN users u ON w.user_id = u.id
ORDER BY w.created_at DESC;

SELECT 
    a.id,
    u.username,
    a.title,
    a.message,
    a.severity,
    a.read,
    a.created_at
FROM alerts a
LEFT JOIN users u ON a.user_id = u.id
ORDER BY a.created_at DESC;

SELECT 
    ast.id,
    u.username,
    ast.title,
    ast.asset_type,
    ast.file_format,
    ast.size_bytes,
    ast.created_at
FROM assets ast
LEFT JOIN users u ON ast.user_id = u.id
ORDER BY ast.created_at DESC;

SELECT 
    t.thread_id,
    u.username,
    t.created_at
FROM thread_ownership t
LEFT JOIN users u ON t.user_id = u.id
ORDER BY t.created_at DESC;


