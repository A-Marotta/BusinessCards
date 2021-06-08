require 'pg'

def run_sql(sql, params = [])
    db = PG.connect(dbname: 'business_card')  
    res = db.exec_params(sql, params)
    db.close 
  
    return res
end