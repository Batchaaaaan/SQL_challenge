# Enterprise Relationship Diagram

Using the following DDL schema details to create an ERD for all the Clique Bait datasets.

#### Solution:
```sql
TABLE event_identifier {
  event_type INTEGER
  event_name VARCHAR(13)
}

TABLE campaign_identifier {
  campaign_id INTEGER
  products VARCHAR(3)
  campaign_name VARCHAR(33)
  start_date TIMESTAMP
  end_date TIMESTAMP
}

TABLE page_hierarchy {
  page_id INTEGER
  page_name VARCHAR(14)
  product_category VARCHAR(9)
  product_id INTEGER
}

TABLE users {
  user_id INTEGER
  cookie_id VARCHAR(6)
  start_date TIMESTAMP
}

TABLE events {
  visit_id VARCHAR(6)
  cookie_id VARCHAR(6)
  page_id INTEGER
  event_type INTEGER
  sequence_number INTEGER
  event_time TIMESTAMP
  }

Ref: "events"."cookie_id" < "users"."cookie_id"

Ref: "events"."event_type" < "event_identifier"."event_type"

Ref: "events"."page_id" < "page_hierarchy"."page_id"
```
#### Output:
<div align=center><img src="https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%236_Clique_Bait/images/case6_erd.png?raw=true" alt='case6_erd' width=900></div>
