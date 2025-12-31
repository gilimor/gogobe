"""
AI Matching Statistics Endpoint
Add this to admin.py
"""

@router.get("/ai/stats")
async def get_ai_stats():
    """Get AI matching statistics"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # Pending matches
        cur.execute("""
            SELECT COUNT(*) as count FROM product_master_links 
            WHERE match_method = 'llm_pending'
        """)
        pending = cur.fetchone()['count'] or 0
        
        # Approved matches
        cur.execute("""
            SELECT COUNT(*) as count FROM product_master_links 
            WHERE match_method = 'manual_approved'
        """)
        approved = cur.fetchone()['count'] or 0
        
        # Rejected matches (from feedback)
        cur.execute("""
            SELECT COUNT(*) as count FROM matching_feedback 
            WHERE feedback_type = 'reject'
        """)
        rejected = cur.fetchone()['count'] or 0
        
        # Total products with AI suggestions
        cur.execute("""
            SELECT COUNT(DISTINCT product_id) as count FROM product_master_links 
            WHERE match_method IN ('llm_pending', 'llm_suggested', 'manual_approved')
        """)
        total = cur.fetchone()['count'] or 0
        
        return {
            "pending": pending,
            "approved": approved,
            "rejected": rejected,
            "total": total
        }
    finally:
        cur.close()
        conn.close()
