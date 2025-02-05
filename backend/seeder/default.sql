INSERT INTO public.roles
("name")
VALUES('pet owner'),('pet daycare provider'),('vet');


INSERT INTO public.vet_specialties ("name") VALUES
('General Practice'),
('Preventive Medicine'),
('Emergency & Critical Care'),
('Internal Medicine'),
('Cardiology'),
('Neurology'),
('Oncology'),
('Gastroenterology'),
('Dermatology & Allergy Care'),
('Dentistry & Oral Surgery'),
('Behavioral Medicine'),
('Surgery & Orthopedics'),
('Soft Tissue Surgery'),
('Orthopedic Surgery'),
('Ophthalmology'),
('Rehabilitation & Physical Therapy'),
('Exotic & Small Animal Care');

INSERT INTO public.species
("name")
VALUES('small sized dog, cats, parrots'), ('medium sized dog'), ('large sized dog');

INSERT INTO public.size_categories
("name", min_weight, max_weight) values
('small', 0, 10),
('medium', 11, 26),
('large', 27, 45),
('giant', 45, 100);
