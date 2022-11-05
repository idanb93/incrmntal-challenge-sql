insert into analytics (customer_id, item_id, date, spend, impressions, clicks, conversions)
select cid,
       iid,
       date,
       abs(round(('x' ||
                  translate(uuid_generate_v5(cid, substring(iid::text from 1 for 8))::text, '-', ''))::bit(58)::bigint /
                 ('x' || translate(uuid_generate_v5(cid, date::text)::text, '-', ''))::bit(32)::bigint::float) /
           100.0),
       abs(round(('x' || translate(uuid_generate_v5(cid, substring(iid::text from 9 for 16))::text, '-',
                                   ''))::bit(58)::bigint /
                 ('x' || translate(uuid_generate_v5(cid, date::text)::text, '-', ''))::bit(32)::bigint::float) /
           1000.0),
       abs(round(('x' || translate(uuid_generate_v5(cid, substring(iid::text from 17 for 24))::text, '-',
                                   ''))::bit(58)::bigint /
                 ('x' || translate(uuid_generate_v5(cid, date::text)::text, '-', ''))::bit(32)::bigint::float) /
           10000.0),
       abs(round(('x' || translate(uuid_generate_v5(cid, substring(iid::text from 25 for 32))::text, '-',
                                   ''))::bit(58)::bigint /
                 ('x' || translate(uuid_generate_v5(cid, date::text)::text, '-', ''))::bit(32)::bigint::float) /
           100000.0)
from (select i.customer_id as cid, i.item_id iid from item i) cq,
     (select d as date from generate_series(timestamp '2022-01-03', timestamp '2022-02-03', interval '1 day') d) dq
where iid <> uuid_nil()
  and uuid_generate_v5(uuid_nil(), iid::text) > '0FFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF'
  and uuid_generate_v5(iid, date::text) > '2FFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF';
