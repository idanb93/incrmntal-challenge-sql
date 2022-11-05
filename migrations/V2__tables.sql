create table customer
(
    customer_id   uuid      not null default uuid_generate_v4(),
    full_name     text      not null,
    display_name  text      not null,
    internal_name citext    not null,

    created_at    timestamp not null default (now() at time zone 'utc'),
    updated_at    timestamp not null default (now() at time zone 'utc'),

    constraint unique_customer_full_name unique (full_name),
    constraint unique_customer_display_name unique (display_name),
    constraint unique_customer_internal_name unique (internal_name),

    primary key (customer_id)
);


create table contact_kind
(
    contact_kind_id uuid   not null default uuid_generate_v4(),
    key             citext not null,
    display_name    text   not null,

    constraint unique_contact_kind_key unique (key),

    primary key (contact_kind_id)
);


create table contact
(
    customer_id     uuid      not null references customer (customer_id) on update cascade on delete cascade,
    contact_kind_id uuid      not null references contact_kind (contact_kind_id) on update cascade on delete cascade,
    display_name    citext    not null,
    value           citext    not null,

    created_at      timestamp not null default (now() at time zone 'utc'),
    updated_at      timestamp not null default (now() at time zone 'utc'),

    primary key (customer_id, contact_kind_id, display_name)
);


create table item
(
    customer_id    uuid      not null references customer (customer_id) on update cascade on delete cascade,
    parent_item_id uuid      not null default uuid_nil(),
    item_id        uuid      not null default uuid_generate_v4(),
    display_name   text      not null default '',
    full_name      text      not null default '',

    created_at     timestamp not null default (now() at time zone 'utc'),
    updated_at     timestamp not null default (now() at time zone 'utc'),

    constraint parent_ref foreign key (customer_id, parent_item_id)
        references item (customer_id, item_id)
        on update cascade on delete cascade,

    constraint unique_item_full_name unique (customer_id, full_name),

    primary key (customer_id, item_id)
);

create index item_customer_id on item (customer_id);
create index item_item_id on item (item_id);


create table analytics
(
    customer_id uuid not null,
    item_id     uuid not null,

    spend       double precision,
    impressions double precision,
    clicks      double precision,
    conversions double precision,

    date        date not null,

    primary key (customer_id, item_id, date)
);
