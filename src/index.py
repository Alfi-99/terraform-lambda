import pymysql
import os
import datetime

def lambda_handler(event, context):
    db_host = os.environ['DB_HOST']
    db_user = os.environ['DB_USER']
    db_pass = os.environ['DB_PASS']
    db_name = os.environ['DB_NAME']

    try:
        conn = pymysql.connect(host=db_host, user=db_user, passwd=db_pass, db=db_name, connect_timeout=5)
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS cron_logs (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    event_message VARCHAR(255),
                    executed_at DATETIME
                )
            """)
            sql = "INSERT INTO cron_logs (event_message, executed_at) VALUES (%s, %s)"
            cur.execute(sql, ("Data insertion via Terraform Lambda Cron", datetime.datetime.now()))
        conn.commit()
        print("Success: Data inserted to RDS")
        return {"status": "success"}
    except Exception as e:
        print(f"Error: {e}")
        return {"status": "error", "message": str(e)}
    finally:
        if 'conn' in locals():
            conn.close()