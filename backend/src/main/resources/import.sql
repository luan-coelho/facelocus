INSERT INTO public.tb_user (id, active, createdat, updatedat, cpf, email, name, password, surname)
VALUES (1, true, '2024-02-17 16:28:21.743229', null, '07791230186', 'luancoelho.dev@gmail.com', 'Luan',
        '$2a$10$0xYWYLQX4UBpzpqDQaMsvuIZHEKaR5Y5j9UKsWyo4vYNpc01wXzPS', 'Coêlho de Souza');

INSERT INTO public.tb_user (id, active, createdat, updatedat, cpf, email, name, password, surname)
VALUES (2, true, '2024-02-17 17:05:18.000000', null, '98718924115', 'mazi@gmail.com', 'Mazilene',
        '$2a$10$0xYWYLQX4UBpzpqDQaMsvuIZHEKaR5Y5j9UKsWyo4vYNpc01wXzPS', 'Pereira de Souza');

INSERT INTO public.event (active, allowticketrequests, administrator_id, createdat, id, updatedat, code, description)
VALUES (true, true, 1, '2024-02-17 17:12:05.000000', 1, null, 'QTR123', 'Banco de Dados I');

INSERT INTO public.location (event_id, id, description, latitude, longitude)
VALUES (1, 1, 'Minha casa', '-10.179463618961364', '-48.361939849308065');

INSERT INTO public.event_tb_user (events_id, users_id)
VALUES (1, 2);

INSERT INTO public.facephoto (active, createdat, id, size, updatedat, user_id, dtype, bucket, filename, filepath,
                              objectkey)
VALUES (true, '2024-02-29 13:47:58.757759', 1, null, null, 1, 'FacePhotoS3', 'facelocus', 'luan.jpg', null,
        '1/luan.jpg');