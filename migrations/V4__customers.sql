insert into customer (customer_id, full_name, display_name, internal_name)
values ('e83c7beb-e3d2-45e6-8879-37b608b79da5', 'INCRMNTAL Ltd.', 'INCRMNTAL', 'incrmntal');

insert into contact (customer_id, contact_kind_id, display_name, value)
values ('e83c7beb-e3d2-45e6-8879-37b608b79da5', 'ce5fd477-43c1-48bf-a4b4-52946ae0b222',
        'Headquarters', E'Tuval St 40,\nRamat Gan, 52522,\nIsrael'),
       ('e83c7beb-e3d2-45e6-8879-37b608b79da5', '61276929-17d6-4c38-bfe3-66d2502cc74c',
        'Maor (Founder)', 'maor@incrmntal.com'),
       ('e83c7beb-e3d2-45e6-8879-37b608b79da5', '61276929-17d6-4c38-bfe3-66d2502cc74c',
        'Moti (Co-Founder)', 'moti@incrmntal.com');


insert into customer (customer_id, full_name, display_name, internal_name)
values ('57a2df4d-a3f6-4bdd-9e3f-5fe0b0959e6f', 'Amazon Europe Core S.à r.l.', 'Amazon Europe', 'amazon');

insert into contact (customer_id, contact_kind_id, display_name, value)
values ('57a2df4d-a3f6-4bdd-9e3f-5fe0b0959e6f', 'ce5fd477-43c1-48bf-a4b4-52946ae0b222',
        'Headquarters',
        E'Amazon Europe Core S.à r.l. (Société à responsabilité limitée)\n38 avenue John F. Kennedy\nL-1855 Luxemburg');


insert into customer (customer_id, full_name, display_name, internal_name)
values ('5e5383aa-849a-43d3-9c46-d23c6f992b53', '1&1 Drillisch AG', '1&1', '1und1');

insert into contact (customer_id, contact_kind_id, display_name, value)
values ('5e5383aa-849a-43d3-9c46-d23c6f992b53', 'ce5fd477-43c1-48bf-a4b4-52946ae0b222',
        'Headquarters', E'Elgendorfer Straße 57\n56410 Montabaur'),
       ('5e5383aa-849a-43d3-9c46-d23c6f992b53', '61276929-17d6-4c38-bfe3-66d2502cc74c',
        'Press', 'press@1und1.de'),
       ('5e5383aa-849a-43d3-9c46-d23c6f992b53', '914642ef-5612-4225-939d-efc5a39eb3b1',
        'Offices', '+49 2602 96-0'),
       ('5e5383aa-849a-43d3-9c46-d23c6f992b53', '61276929-17d6-4c38-bfe3-66d2502cc74c',
        'Investor Relations', 'ir@1und1.de'),
       ('5e5383aa-849a-43d3-9c46-d23c6f992b53', '914642ef-5612-4225-939d-efc5a39eb3b1',
        'Investor Relations', '+49 6181 412 200'),
       ('5e5383aa-849a-43d3-9c46-d23c6f992b53', '914642ef-5612-4225-939d-efc5a39eb3b1',
        'Customer Support', '+49 721 9605727');



insert into customer (customer_id, full_name, display_name, internal_name)
values ('27155a2c-74a1-4cd6-b00e-909914542fc9', 'Honda Motor Co., Ltd.', 'Honda Motors', 'honda');
