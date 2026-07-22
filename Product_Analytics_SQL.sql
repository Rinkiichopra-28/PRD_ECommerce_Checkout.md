-- 1. Calculate Checkout Funnel Drop-off Rate
WITH FunnelSteps AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'cart_viewed' THEN 1 ELSE 0 END) AS viewed_cart,
        MAX(CASE WHEN event_name = 'checkout_started' THEN 1 ELSE 0 END) AS started_checkout,
        MAX(CASE WHEN event_name = 'payment_info_entered' THEN 1 ELSE 0 END) AS entered_payment,
        MAX(CASE WHEN event_name = 'purchase_completed' THEN 1 ELSE 0 END) AS completed_purchase
    FROM app_events
    WHERE event_date >= DATEADD(day, -30, CURRENT_DATE)
    GROUP BY user_id
)
SELECT 
    COUNT(user_id) AS total_cart_views,
    SUM(started_checkout) AS started_checkout_count,
    SUM(completed_purchase) AS completed_purchase_count,
    ROUND((1.0 - (SUM(completed_purchase) * 1.0 / SUM(started_checkout))) * 100, 2) AS checkout_abandonment_rate_pct
FROM FunnelSteps;
