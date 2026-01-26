--
-- PostgreSQL database dump
--

\restrict fvzUXRrYY5n3JvvA0KoVS25dpSXyeMctTEfwLbqThpTJz6pRxMb8IlC8bE6DPcE

-- Dumped from database version 15.4
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-20 19:19:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 48 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 7599 (class 0 OID 0)
-- Dependencies: 48
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 2782 (class 1255 OID 38522751)
-- Name: fn_auditoria(); Type: FUNCTION; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE FUNCTION public.fn_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auditoria (
        tabla_afectada,
        operacion,
        usuario_bd,
        registro_id,
        descripcion
    )
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        current_user,
        CASE
            WHEN TG_OP = 'DELETE' THEN OLD.id_prestamo
            ELSE NEW.id_prestamo
        END,
        'Operación realizada sobre la tabla ' || TG_TABLE_NAME
    );

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_auditoria() OWNER TO uopjjbtugtnt5ilyi0t3;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 349 (class 1259 OID 38522737)
-- Name: auditoria; Type: TABLE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TABLE public.auditoria (
    id_auditoria integer NOT NULL,
    tabla_afectada character varying(50) NOT NULL,
    operacion character varying(10) NOT NULL,
    usuario_bd character varying(50) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    registro_id integer,
    descripcion text
);


ALTER TABLE public.auditoria OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 348 (class 1259 OID 38522736)
-- Name: auditoria_id_auditoria_seq; Type: SEQUENCE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE SEQUENCE public.auditoria_id_auditoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditoria_id_auditoria_seq OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 7601 (class 0 OID 0)
-- Dependencies: 348
-- Name: auditoria_id_auditoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER SEQUENCE public.auditoria_id_auditoria_seq OWNED BY public.auditoria.id_auditoria;


--
-- TOC entry 339 (class 1259 OID 38522634)
-- Name: autor; Type: TABLE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TABLE public.autor (
    id_autor integer NOT NULL,
    nombre character varying(100) NOT NULL,
    nacionalidad character varying(50)
);


ALTER TABLE public.autor OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 338 (class 1259 OID 38522633)
-- Name: autor_id_autor_seq; Type: SEQUENCE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE SEQUENCE public.autor_id_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.autor_id_autor_seq OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 7602 (class 0 OID 0)
-- Dependencies: 338
-- Name: autor_id_autor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER SEQUENCE public.autor_id_autor_seq OWNED BY public.autor.id_autor;


--
-- TOC entry 337 (class 1259 OID 38522623)
-- Name: categoria; Type: TABLE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TABLE public.categoria (
    id_categoria integer NOT NULL,
    nombre_categoria character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.categoria OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 336 (class 1259 OID 38522622)
-- Name: categoria_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE SEQUENCE public.categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_id_categoria_seq OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 7603 (class 0 OID 0)
-- Dependencies: 336
-- Name: categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.categoria.id_categoria;


--
-- TOC entry 343 (class 1259 OID 38522657)
-- Name: libro; Type: TABLE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TABLE public.libro (
    id_libro integer NOT NULL,
    titulo character varying(150) NOT NULL,
    isbn character varying(20) NOT NULL,
    anio_publicacion integer,
    ejemplares_totales integer NOT NULL,
    ejemplares_disponibles integer NOT NULL,
    estado character varying(20) NOT NULL,
    id_categoria integer NOT NULL,
    CONSTRAINT libro_anio_publicacion_check CHECK ((anio_publicacion >= 1500)),
    CONSTRAINT libro_ejemplares_disponibles_check CHECK ((ejemplares_disponibles >= 0)),
    CONSTRAINT libro_ejemplares_totales_check CHECK ((ejemplares_totales > 0)),
    CONSTRAINT libro_estado_check CHECK (((estado)::text = ANY ((ARRAY['Disponible'::character varying, 'No disponible'::character varying])::text[])))
);


ALTER TABLE public.libro OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 344 (class 1259 OID 38522674)
-- Name: libro_autor; Type: TABLE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TABLE public.libro_autor (
    id_libro integer NOT NULL,
    id_autor integer NOT NULL
);


ALTER TABLE public.libro_autor OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 342 (class 1259 OID 38522656)
-- Name: libro_id_libro_seq; Type: SEQUENCE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE SEQUENCE public.libro_id_libro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.libro_id_libro_seq OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 7604 (class 0 OID 0)
-- Dependencies: 342
-- Name: libro_id_libro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER SEQUENCE public.libro_id_libro_seq OWNED BY public.libro.id_libro;


--
-- TOC entry 346 (class 1259 OID 38522690)
-- Name: prestamo; Type: TABLE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TABLE public.prestamo (
    id_prestamo integer NOT NULL,
    fecha_prestamo date DEFAULT CURRENT_DATE NOT NULL,
    fecha_devolucion date NOT NULL,
    fecha_entrega date,
    estado character varying(20) NOT NULL,
    id_usuario integer NOT NULL,
    id_libro integer NOT NULL,
    CONSTRAINT prestamo_estado_check CHECK (((estado)::text = ANY ((ARRAY['Prestado'::character varying, 'Devuelto'::character varying, 'Retrasado'::character varying])::text[])))
);


ALTER TABLE public.prestamo OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 345 (class 1259 OID 38522689)
-- Name: prestamo_id_prestamo_seq; Type: SEQUENCE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE SEQUENCE public.prestamo_id_prestamo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prestamo_id_prestamo_seq OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 7605 (class 0 OID 0)
-- Dependencies: 345
-- Name: prestamo_id_prestamo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER SEQUENCE public.prestamo_id_prestamo_seq OWNED BY public.prestamo.id_prestamo;


--
-- TOC entry 341 (class 1259 OID 38522641)
-- Name: usuario; Type: TABLE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    cedula character varying(10) NOT NULL,
    correo character varying(100),
    telefono character varying(15),
    tipo_usuario character varying(20) NOT NULL,
    fecha_registro date DEFAULT CURRENT_DATE NOT NULL,
    estado character varying(10) NOT NULL,
    password_hash character varying(255),
    CONSTRAINT usuario_estado_check CHECK (((estado)::text = ANY ((ARRAY['Activo'::character varying, 'Inactivo'::character varying])::text[]))),
    CONSTRAINT usuario_tipo_usuario_check CHECK (((tipo_usuario)::text = ANY ((ARRAY['Estudiante'::character varying, 'Docente'::character varying, 'Externo'::character varying])::text[])))
);


ALTER TABLE public.usuario OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 340 (class 1259 OID 38522640)
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 7606 (class 0 OID 0)
-- Dependencies: 340
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- TOC entry 347 (class 1259 OID 38522708)
-- Name: vw_prestamos_activos; Type: VIEW; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE VIEW public.vw_prestamos_activos AS
 SELECT u.nombre,
    l.titulo,
    p.fecha_devolucion
   FROM ((public.prestamo p
     JOIN public.usuario u ON ((p.id_usuario = u.id_usuario)))
     JOIN public.libro l ON ((p.id_libro = l.id_libro)))
  WHERE ((p.estado)::text = 'Prestado'::text);


ALTER VIEW public.vw_prestamos_activos OWNER TO uopjjbtugtnt5ilyi0t3;

--
-- TOC entry 7382 (class 2604 OID 38522740)
-- Name: auditoria id_auditoria; Type: DEFAULT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.auditoria ALTER COLUMN id_auditoria SET DEFAULT nextval('public.auditoria_id_auditoria_seq'::regclass);


--
-- TOC entry 7376 (class 2604 OID 38522637)
-- Name: autor id_autor; Type: DEFAULT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.autor ALTER COLUMN id_autor SET DEFAULT nextval('public.autor_id_autor_seq'::regclass);


--
-- TOC entry 7375 (class 2604 OID 38522626)
-- Name: categoria id_categoria; Type: DEFAULT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.categoria ALTER COLUMN id_categoria SET DEFAULT nextval('public.categoria_id_categoria_seq'::regclass);


--
-- TOC entry 7379 (class 2604 OID 38522660)
-- Name: libro id_libro; Type: DEFAULT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.libro ALTER COLUMN id_libro SET DEFAULT nextval('public.libro_id_libro_seq'::regclass);


--
-- TOC entry 7380 (class 2604 OID 38522693)
-- Name: prestamo id_prestamo; Type: DEFAULT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.prestamo ALTER COLUMN id_prestamo SET DEFAULT nextval('public.prestamo_id_prestamo_seq'::regclass);


--
-- TOC entry 7377 (class 2604 OID 38522644)
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- TOC entry 7593 (class 0 OID 38522737)
-- Dependencies: 349
-- Data for Name: auditoria; Type: TABLE DATA; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

COPY public.auditoria (id_auditoria, tabla_afectada, operacion, usuario_bd, fecha, registro_id, descripcion) FROM stdin;
1	prestamo	INSERT	uopjjbtugtnt5ilyi0t3	2026-01-20 18:43:09.305097	1004	Operación realizada sobre la tabla prestamo
2	prestamo	UPDATE	uopjjbtugtnt5ilyi0t3	2026-01-20 18:46:26.799243	1	Operación realizada sobre la tabla prestamo
3	prestamo	DELETE	uopjjbtugtnt5ilyi0t3	2026-01-20 18:46:43.774821	1	Operación realizada sobre la tabla prestamo
\.


--
-- TOC entry 7584 (class 0 OID 38522634)
-- Dependencies: 339
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

COPY public.autor (id_autor, nombre, nacionalidad) FROM stdin;
1	Gabriel García Márquez	Colombiano
2	Isabel Allende	Chilena
3	Stephen Hawking	Británico
4	Robert Martin	Estadounidense
\.


--
-- TOC entry 7582 (class 0 OID 38522623)
-- Dependencies: 337
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

COPY public.categoria (id_categoria, nombre_categoria, descripcion) FROM stdin;
1	Ciencia	Libros científicos y académicos
2	Literatura	Novelas y cuentos
3	Tecnología	Informática y sistemas
4	Historia	Libros históricos
5	Filosofia	Libros filosóficos
\.


--
-- TOC entry 7588 (class 0 OID 38522657)
-- Dependencies: 343
-- Data for Name: libro; Type: TABLE DATA; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

COPY public.libro (id_libro, titulo, isbn, anio_publicacion, ejemplares_totales, ejemplares_disponibles, estado, id_categoria) FROM stdin;
2	La casa de los espíritus	ISBN002	1982	4	2	Disponible	2
3	Breve historia del tiempo	ISBN003	1988	3	1	Disponible	1
4	Clean Code	ISBN004	2008	6	6	Disponible	3
1	Cien años de soledad	ISBN001	1967	5	2	Disponible	2
\.


--
-- TOC entry 7589 (class 0 OID 38522674)
-- Dependencies: 344
-- Data for Name: libro_autor; Type: TABLE DATA; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

COPY public.libro_autor (id_libro, id_autor) FROM stdin;
1	1
2	2
3	3
4	4
\.


--
-- TOC entry 7591 (class 0 OID 38522690)
-- Dependencies: 346
-- Data for Name: prestamo; Type: TABLE DATA; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

COPY public.prestamo (id_prestamo, fecha_prestamo, fecha_devolucion, fecha_entrega, estado, id_usuario, id_libro) FROM stdin;
502	2026-01-20	2026-01-27	\N	Prestado	1	1
503	2026-01-20	2026-01-27	\N	Prestado	1	1
504	2026-01-20	2026-01-27	\N	Prestado	1	1
505	2026-01-20	2026-01-27	\N	Prestado	1	1
506	2026-01-20	2026-01-27	\N	Prestado	1	1
507	2026-01-20	2026-01-27	\N	Prestado	1	1
508	2026-01-20	2026-01-27	\N	Prestado	1	1
509	2026-01-20	2026-01-27	\N	Prestado	1	1
510	2026-01-20	2026-01-27	\N	Prestado	1	1
511	2026-01-20	2026-01-27	\N	Prestado	1	1
512	2026-01-20	2026-01-27	\N	Prestado	1	1
513	2026-01-20	2026-01-27	\N	Prestado	1	1
514	2026-01-20	2026-01-27	\N	Prestado	1	1
515	2026-01-20	2026-01-27	\N	Prestado	1	1
516	2026-01-20	2026-01-27	\N	Prestado	1	1
517	2026-01-20	2026-01-27	\N	Prestado	1	1
518	2026-01-20	2026-01-27	\N	Prestado	1	1
519	2026-01-20	2026-01-27	\N	Prestado	1	1
520	2026-01-20	2026-01-27	\N	Prestado	1	1
521	2026-01-20	2026-01-27	\N	Prestado	1	1
522	2026-01-20	2026-01-27	\N	Prestado	1	1
523	2026-01-20	2026-01-27	\N	Prestado	1	1
524	2026-01-20	2026-01-27	\N	Prestado	1	1
525	2026-01-20	2026-01-27	\N	Prestado	1	1
526	2026-01-20	2026-01-27	\N	Prestado	1	1
527	2026-01-20	2026-01-27	\N	Prestado	1	1
528	2026-01-20	2026-01-27	\N	Prestado	1	1
529	2026-01-20	2026-01-27	\N	Prestado	1	1
530	2026-01-20	2026-01-27	\N	Prestado	1	1
531	2026-01-20	2026-01-27	\N	Prestado	1	1
532	2026-01-20	2026-01-27	\N	Prestado	1	1
533	2026-01-20	2026-01-27	\N	Prestado	1	1
534	2026-01-20	2026-01-27	\N	Prestado	1	1
535	2026-01-20	2026-01-27	\N	Prestado	1	1
536	2026-01-20	2026-01-27	\N	Prestado	1	1
537	2026-01-20	2026-01-27	\N	Prestado	1	1
538	2026-01-20	2026-01-27	\N	Prestado	1	1
539	2026-01-20	2026-01-27	\N	Prestado	1	1
540	2026-01-20	2026-01-27	\N	Prestado	1	1
541	2026-01-20	2026-01-27	\N	Prestado	1	1
542	2026-01-20	2026-01-27	\N	Prestado	1	1
543	2026-01-20	2026-01-27	\N	Prestado	1	1
544	2026-01-20	2026-01-27	\N	Prestado	1	1
545	2026-01-20	2026-01-27	\N	Prestado	1	1
546	2026-01-20	2026-01-27	\N	Prestado	1	1
547	2026-01-20	2026-01-27	\N	Prestado	1	1
548	2026-01-20	2026-01-27	\N	Prestado	1	1
549	2026-01-20	2026-01-27	\N	Prestado	1	1
550	2026-01-20	2026-01-27	\N	Prestado	1	1
551	2026-01-20	2026-01-27	\N	Prestado	1	1
552	2026-01-20	2026-01-27	\N	Prestado	1	1
553	2026-01-20	2026-01-27	\N	Prestado	1	1
554	2026-01-20	2026-01-27	\N	Prestado	1	1
555	2026-01-20	2026-01-27	\N	Prestado	1	1
556	2026-01-20	2026-01-27	\N	Prestado	1	1
557	2026-01-20	2026-01-27	\N	Prestado	1	1
558	2026-01-20	2026-01-27	\N	Prestado	1	1
559	2026-01-20	2026-01-27	\N	Prestado	1	1
560	2026-01-20	2026-01-27	\N	Prestado	1	1
561	2026-01-20	2026-01-27	\N	Prestado	1	1
562	2026-01-20	2026-01-27	\N	Prestado	1	1
563	2026-01-20	2026-01-27	\N	Prestado	1	1
564	2026-01-20	2026-01-27	\N	Prestado	1	1
565	2026-01-20	2026-01-27	\N	Prestado	1	1
566	2026-01-20	2026-01-27	\N	Prestado	1	1
567	2026-01-20	2026-01-27	\N	Prestado	1	1
568	2026-01-20	2026-01-27	\N	Prestado	1	1
569	2026-01-20	2026-01-27	\N	Prestado	1	1
570	2026-01-20	2026-01-27	\N	Prestado	1	1
571	2026-01-20	2026-01-27	\N	Prestado	1	1
572	2026-01-20	2026-01-27	\N	Prestado	1	1
573	2026-01-20	2026-01-27	\N	Prestado	1	1
574	2026-01-20	2026-01-27	\N	Prestado	1	1
575	2026-01-20	2026-01-27	\N	Prestado	1	1
576	2026-01-20	2026-01-27	\N	Prestado	1	1
577	2026-01-20	2026-01-27	\N	Prestado	1	1
578	2026-01-20	2026-01-27	\N	Prestado	1	1
579	2026-01-20	2026-01-27	\N	Prestado	1	1
580	2026-01-20	2026-01-27	\N	Prestado	1	1
581	2026-01-20	2026-01-27	\N	Prestado	1	1
582	2026-01-20	2026-01-27	\N	Prestado	1	1
583	2026-01-20	2026-01-27	\N	Prestado	1	1
584	2026-01-20	2026-01-27	\N	Prestado	1	1
585	2026-01-20	2026-01-27	\N	Prestado	1	1
586	2026-01-20	2026-01-27	\N	Prestado	1	1
587	2026-01-20	2026-01-27	\N	Prestado	1	1
588	2026-01-20	2026-01-27	\N	Prestado	1	1
589	2026-01-20	2026-01-27	\N	Prestado	1	1
590	2026-01-20	2026-01-27	\N	Prestado	1	1
591	2026-01-20	2026-01-27	\N	Prestado	1	1
592	2026-01-20	2026-01-27	\N	Prestado	1	1
593	2026-01-20	2026-01-27	\N	Prestado	1	1
594	2026-01-20	2026-01-27	\N	Prestado	1	1
595	2026-01-20	2026-01-27	\N	Prestado	1	1
596	2026-01-20	2026-01-27	\N	Prestado	1	1
597	2026-01-20	2026-01-27	\N	Prestado	1	1
598	2026-01-20	2026-01-27	\N	Prestado	1	1
599	2026-01-20	2026-01-27	\N	Prestado	1	1
600	2026-01-20	2026-01-27	\N	Prestado	1	1
601	2026-01-20	2026-01-27	\N	Prestado	1	1
602	2026-01-20	2026-01-27	\N	Prestado	1	1
603	2026-01-20	2026-01-27	\N	Prestado	1	1
604	2026-01-20	2026-01-27	\N	Prestado	1	1
605	2026-01-20	2026-01-27	\N	Prestado	1	1
606	2026-01-20	2026-01-27	\N	Prestado	1	1
607	2026-01-20	2026-01-27	\N	Prestado	1	1
608	2026-01-20	2026-01-27	\N	Prestado	1	1
609	2026-01-20	2026-01-27	\N	Prestado	1	1
610	2026-01-20	2026-01-27	\N	Prestado	1	1
611	2026-01-20	2026-01-27	\N	Prestado	1	1
612	2026-01-20	2026-01-27	\N	Prestado	1	1
613	2026-01-20	2026-01-27	\N	Prestado	1	1
614	2026-01-20	2026-01-27	\N	Prestado	1	1
615	2026-01-20	2026-01-27	\N	Prestado	1	1
616	2026-01-20	2026-01-27	\N	Prestado	1	1
617	2026-01-20	2026-01-27	\N	Prestado	1	1
618	2026-01-20	2026-01-27	\N	Prestado	1	1
619	2026-01-20	2026-01-27	\N	Prestado	1	1
620	2026-01-20	2026-01-27	\N	Prestado	1	1
621	2026-01-20	2026-01-27	\N	Prestado	1	1
622	2026-01-20	2026-01-27	\N	Prestado	1	1
623	2026-01-20	2026-01-27	\N	Prestado	1	1
624	2026-01-20	2026-01-27	\N	Prestado	1	1
625	2026-01-20	2026-01-27	\N	Prestado	1	1
626	2026-01-20	2026-01-27	\N	Prestado	1	1
627	2026-01-20	2026-01-27	\N	Prestado	1	1
628	2026-01-20	2026-01-27	\N	Prestado	1	1
629	2026-01-20	2026-01-27	\N	Prestado	1	1
630	2026-01-20	2026-01-27	\N	Prestado	1	1
631	2026-01-20	2026-01-27	\N	Prestado	1	1
632	2026-01-20	2026-01-27	\N	Prestado	1	1
633	2026-01-20	2026-01-27	\N	Prestado	1	1
634	2026-01-20	2026-01-27	\N	Prestado	1	1
635	2026-01-20	2026-01-27	\N	Prestado	1	1
636	2026-01-20	2026-01-27	\N	Prestado	1	1
637	2026-01-20	2026-01-27	\N	Prestado	1	1
638	2026-01-20	2026-01-27	\N	Prestado	1	1
639	2026-01-20	2026-01-27	\N	Prestado	1	1
640	2026-01-20	2026-01-27	\N	Prestado	1	1
641	2026-01-20	2026-01-27	\N	Prestado	1	1
642	2026-01-20	2026-01-27	\N	Prestado	1	1
643	2026-01-20	2026-01-27	\N	Prestado	1	1
644	2026-01-20	2026-01-27	\N	Prestado	1	1
645	2026-01-20	2026-01-27	\N	Prestado	1	1
646	2026-01-20	2026-01-27	\N	Prestado	1	1
647	2026-01-20	2026-01-27	\N	Prestado	1	1
648	2026-01-20	2026-01-27	\N	Prestado	1	1
649	2026-01-20	2026-01-27	\N	Prestado	1	1
650	2026-01-20	2026-01-27	\N	Prestado	1	1
651	2026-01-20	2026-01-27	\N	Prestado	1	1
652	2026-01-20	2026-01-27	\N	Prestado	1	1
653	2026-01-20	2026-01-27	\N	Prestado	1	1
654	2026-01-20	2026-01-27	\N	Prestado	1	1
655	2026-01-20	2026-01-27	\N	Prestado	1	1
656	2026-01-20	2026-01-27	\N	Prestado	1	1
657	2026-01-20	2026-01-27	\N	Prestado	1	1
658	2026-01-20	2026-01-27	\N	Prestado	1	1
659	2026-01-20	2026-01-27	\N	Prestado	1	1
660	2026-01-20	2026-01-27	\N	Prestado	1	1
661	2026-01-20	2026-01-27	\N	Prestado	1	1
662	2026-01-20	2026-01-27	\N	Prestado	1	1
663	2026-01-20	2026-01-27	\N	Prestado	1	1
664	2026-01-20	2026-01-27	\N	Prestado	1	1
665	2026-01-20	2026-01-27	\N	Prestado	1	1
666	2026-01-20	2026-01-27	\N	Prestado	1	1
667	2026-01-20	2026-01-27	\N	Prestado	1	1
668	2026-01-20	2026-01-27	\N	Prestado	1	1
669	2026-01-20	2026-01-27	\N	Prestado	1	1
670	2026-01-20	2026-01-27	\N	Prestado	1	1
671	2026-01-20	2026-01-27	\N	Prestado	1	1
672	2026-01-20	2026-01-27	\N	Prestado	1	1
673	2026-01-20	2026-01-27	\N	Prestado	1	1
674	2026-01-20	2026-01-27	\N	Prestado	1	1
675	2026-01-20	2026-01-27	\N	Prestado	1	1
676	2026-01-20	2026-01-27	\N	Prestado	1	1
677	2026-01-20	2026-01-27	\N	Prestado	1	1
678	2026-01-20	2026-01-27	\N	Prestado	1	1
679	2026-01-20	2026-01-27	\N	Prestado	1	1
680	2026-01-20	2026-01-27	\N	Prestado	1	1
681	2026-01-20	2026-01-27	\N	Prestado	1	1
682	2026-01-20	2026-01-27	\N	Prestado	1	1
683	2026-01-20	2026-01-27	\N	Prestado	1	1
684	2026-01-20	2026-01-27	\N	Prestado	1	1
685	2026-01-20	2026-01-27	\N	Prestado	1	1
686	2026-01-20	2026-01-27	\N	Prestado	1	1
687	2026-01-20	2026-01-27	\N	Prestado	1	1
688	2026-01-20	2026-01-27	\N	Prestado	1	1
689	2026-01-20	2026-01-27	\N	Prestado	1	1
690	2026-01-20	2026-01-27	\N	Prestado	1	1
691	2026-01-20	2026-01-27	\N	Prestado	1	1
692	2026-01-20	2026-01-27	\N	Prestado	1	1
693	2026-01-20	2026-01-27	\N	Prestado	1	1
694	2026-01-20	2026-01-27	\N	Prestado	1	1
695	2026-01-20	2026-01-27	\N	Prestado	1	1
696	2026-01-20	2026-01-27	\N	Prestado	1	1
697	2026-01-20	2026-01-27	\N	Prestado	1	1
698	2026-01-20	2026-01-27	\N	Prestado	1	1
699	2026-01-20	2026-01-27	\N	Prestado	1	1
700	2026-01-20	2026-01-27	\N	Prestado	1	1
701	2026-01-20	2026-01-27	\N	Prestado	1	1
702	2026-01-20	2026-01-27	\N	Prestado	1	1
703	2026-01-20	2026-01-27	\N	Prestado	1	1
704	2026-01-20	2026-01-27	\N	Prestado	1	1
705	2026-01-20	2026-01-27	\N	Prestado	1	1
706	2026-01-20	2026-01-27	\N	Prestado	1	1
707	2026-01-20	2026-01-27	\N	Prestado	1	1
708	2026-01-20	2026-01-27	\N	Prestado	1	1
709	2026-01-20	2026-01-27	\N	Prestado	1	1
710	2026-01-20	2026-01-27	\N	Prestado	1	1
711	2026-01-20	2026-01-27	\N	Prestado	1	1
712	2026-01-20	2026-01-27	\N	Prestado	1	1
713	2026-01-20	2026-01-27	\N	Prestado	1	1
714	2026-01-20	2026-01-27	\N	Prestado	1	1
715	2026-01-20	2026-01-27	\N	Prestado	1	1
716	2026-01-20	2026-01-27	\N	Prestado	1	1
717	2026-01-20	2026-01-27	\N	Prestado	1	1
718	2026-01-20	2026-01-27	\N	Prestado	1	1
719	2026-01-20	2026-01-27	\N	Prestado	1	1
720	2026-01-20	2026-01-27	\N	Prestado	1	1
721	2026-01-20	2026-01-27	\N	Prestado	1	1
722	2026-01-20	2026-01-27	\N	Prestado	1	1
723	2026-01-20	2026-01-27	\N	Prestado	1	1
724	2026-01-20	2026-01-27	\N	Prestado	1	1
725	2026-01-20	2026-01-27	\N	Prestado	1	1
726	2026-01-20	2026-01-27	\N	Prestado	1	1
727	2026-01-20	2026-01-27	\N	Prestado	1	1
728	2026-01-20	2026-01-27	\N	Prestado	1	1
729	2026-01-20	2026-01-27	\N	Prestado	1	1
730	2026-01-20	2026-01-27	\N	Prestado	1	1
731	2026-01-20	2026-01-27	\N	Prestado	1	1
732	2026-01-20	2026-01-27	\N	Prestado	1	1
733	2026-01-20	2026-01-27	\N	Prestado	1	1
734	2026-01-20	2026-01-27	\N	Prestado	1	1
735	2026-01-20	2026-01-27	\N	Prestado	1	1
736	2026-01-20	2026-01-27	\N	Prestado	1	1
737	2026-01-20	2026-01-27	\N	Prestado	1	1
738	2026-01-20	2026-01-27	\N	Prestado	1	1
739	2026-01-20	2026-01-27	\N	Prestado	1	1
740	2026-01-20	2026-01-27	\N	Prestado	1	1
741	2026-01-20	2026-01-27	\N	Prestado	1	1
742	2026-01-20	2026-01-27	\N	Prestado	1	1
743	2026-01-20	2026-01-27	\N	Prestado	1	1
744	2026-01-20	2026-01-27	\N	Prestado	1	1
745	2026-01-20	2026-01-27	\N	Prestado	1	1
746	2026-01-20	2026-01-27	\N	Prestado	1	1
747	2026-01-20	2026-01-27	\N	Prestado	1	1
748	2026-01-20	2026-01-27	\N	Prestado	1	1
749	2026-01-20	2026-01-27	\N	Prestado	1	1
750	2026-01-20	2026-01-27	\N	Prestado	1	1
751	2026-01-20	2026-01-27	\N	Prestado	1	1
752	2026-01-20	2026-01-27	\N	Prestado	1	1
753	2026-01-20	2026-01-27	\N	Prestado	1	1
754	2026-01-20	2026-01-27	\N	Prestado	1	1
755	2026-01-20	2026-01-27	\N	Prestado	1	1
756	2026-01-20	2026-01-27	\N	Prestado	1	1
757	2026-01-20	2026-01-27	\N	Prestado	1	1
758	2026-01-20	2026-01-27	\N	Prestado	1	1
759	2026-01-20	2026-01-27	\N	Prestado	1	1
760	2026-01-20	2026-01-27	\N	Prestado	1	1
761	2026-01-20	2026-01-27	\N	Prestado	1	1
762	2026-01-20	2026-01-27	\N	Prestado	1	1
763	2026-01-20	2026-01-27	\N	Prestado	1	1
764	2026-01-20	2026-01-27	\N	Prestado	1	1
765	2026-01-20	2026-01-27	\N	Prestado	1	1
766	2026-01-20	2026-01-27	\N	Prestado	1	1
767	2026-01-20	2026-01-27	\N	Prestado	1	1
768	2026-01-20	2026-01-27	\N	Prestado	1	1
769	2026-01-20	2026-01-27	\N	Prestado	1	1
770	2026-01-20	2026-01-27	\N	Prestado	1	1
771	2026-01-20	2026-01-27	\N	Prestado	1	1
772	2026-01-20	2026-01-27	\N	Prestado	1	1
773	2026-01-20	2026-01-27	\N	Prestado	1	1
774	2026-01-20	2026-01-27	\N	Prestado	1	1
775	2026-01-20	2026-01-27	\N	Prestado	1	1
776	2026-01-20	2026-01-27	\N	Prestado	1	1
777	2026-01-20	2026-01-27	\N	Prestado	1	1
778	2026-01-20	2026-01-27	\N	Prestado	1	1
779	2026-01-20	2026-01-27	\N	Prestado	1	1
780	2026-01-20	2026-01-27	\N	Prestado	1	1
781	2026-01-20	2026-01-27	\N	Prestado	1	1
782	2026-01-20	2026-01-27	\N	Prestado	1	1
783	2026-01-20	2026-01-27	\N	Prestado	1	1
784	2026-01-20	2026-01-27	\N	Prestado	1	1
785	2026-01-20	2026-01-27	\N	Prestado	1	1
786	2026-01-20	2026-01-27	\N	Prestado	1	1
787	2026-01-20	2026-01-27	\N	Prestado	1	1
788	2026-01-20	2026-01-27	\N	Prestado	1	1
789	2026-01-20	2026-01-27	\N	Prestado	1	1
790	2026-01-20	2026-01-27	\N	Prestado	1	1
791	2026-01-20	2026-01-27	\N	Prestado	1	1
792	2026-01-20	2026-01-27	\N	Prestado	1	1
793	2026-01-20	2026-01-27	\N	Prestado	1	1
794	2026-01-20	2026-01-27	\N	Prestado	1	1
795	2026-01-20	2026-01-27	\N	Prestado	1	1
796	2026-01-20	2026-01-27	\N	Prestado	1	1
797	2026-01-20	2026-01-27	\N	Prestado	1	1
798	2026-01-20	2026-01-27	\N	Prestado	1	1
799	2026-01-20	2026-01-27	\N	Prestado	1	1
800	2026-01-20	2026-01-27	\N	Prestado	1	1
801	2026-01-20	2026-01-27	\N	Prestado	1	1
802	2026-01-20	2026-01-27	\N	Prestado	1	1
803	2026-01-20	2026-01-27	\N	Prestado	1	1
804	2026-01-20	2026-01-27	\N	Prestado	1	1
805	2026-01-20	2026-01-27	\N	Prestado	1	1
806	2026-01-20	2026-01-27	\N	Prestado	1	1
807	2026-01-20	2026-01-27	\N	Prestado	1	1
808	2026-01-20	2026-01-27	\N	Prestado	1	1
809	2026-01-20	2026-01-27	\N	Prestado	1	1
810	2026-01-20	2026-01-27	\N	Prestado	1	1
811	2026-01-20	2026-01-27	\N	Prestado	1	1
812	2026-01-20	2026-01-27	\N	Prestado	1	1
813	2026-01-20	2026-01-27	\N	Prestado	1	1
814	2026-01-20	2026-01-27	\N	Prestado	1	1
815	2026-01-20	2026-01-27	\N	Prestado	1	1
816	2026-01-20	2026-01-27	\N	Prestado	1	1
817	2026-01-20	2026-01-27	\N	Prestado	1	1
818	2026-01-20	2026-01-27	\N	Prestado	1	1
819	2026-01-20	2026-01-27	\N	Prestado	1	1
820	2026-01-20	2026-01-27	\N	Prestado	1	1
821	2026-01-20	2026-01-27	\N	Prestado	1	1
822	2026-01-20	2026-01-27	\N	Prestado	1	1
823	2026-01-20	2026-01-27	\N	Prestado	1	1
824	2026-01-20	2026-01-27	\N	Prestado	1	1
825	2026-01-20	2026-01-27	\N	Prestado	1	1
826	2026-01-20	2026-01-27	\N	Prestado	1	1
827	2026-01-20	2026-01-27	\N	Prestado	1	1
828	2026-01-20	2026-01-27	\N	Prestado	1	1
829	2026-01-20	2026-01-27	\N	Prestado	1	1
830	2026-01-20	2026-01-27	\N	Prestado	1	1
831	2026-01-20	2026-01-27	\N	Prestado	1	1
832	2026-01-20	2026-01-27	\N	Prestado	1	1
833	2026-01-20	2026-01-27	\N	Prestado	1	1
834	2026-01-20	2026-01-27	\N	Prestado	1	1
835	2026-01-20	2026-01-27	\N	Prestado	1	1
836	2026-01-20	2026-01-27	\N	Prestado	1	1
837	2026-01-20	2026-01-27	\N	Prestado	1	1
838	2026-01-20	2026-01-27	\N	Prestado	1	1
839	2026-01-20	2026-01-27	\N	Prestado	1	1
840	2026-01-20	2026-01-27	\N	Prestado	1	1
841	2026-01-20	2026-01-27	\N	Prestado	1	1
842	2026-01-20	2026-01-27	\N	Prestado	1	1
843	2026-01-20	2026-01-27	\N	Prestado	1	1
844	2026-01-20	2026-01-27	\N	Prestado	1	1
845	2026-01-20	2026-01-27	\N	Prestado	1	1
846	2026-01-20	2026-01-27	\N	Prestado	1	1
847	2026-01-20	2026-01-27	\N	Prestado	1	1
848	2026-01-20	2026-01-27	\N	Prestado	1	1
849	2026-01-20	2026-01-27	\N	Prestado	1	1
850	2026-01-20	2026-01-27	\N	Prestado	1	1
851	2026-01-20	2026-01-27	\N	Prestado	1	1
852	2026-01-20	2026-01-27	\N	Prestado	1	1
853	2026-01-20	2026-01-27	\N	Prestado	1	1
854	2026-01-20	2026-01-27	\N	Prestado	1	1
855	2026-01-20	2026-01-27	\N	Prestado	1	1
856	2026-01-20	2026-01-27	\N	Prestado	1	1
857	2026-01-20	2026-01-27	\N	Prestado	1	1
858	2026-01-20	2026-01-27	\N	Prestado	1	1
859	2026-01-20	2026-01-27	\N	Prestado	1	1
860	2026-01-20	2026-01-27	\N	Prestado	1	1
861	2026-01-20	2026-01-27	\N	Prestado	1	1
862	2026-01-20	2026-01-27	\N	Prestado	1	1
863	2026-01-20	2026-01-27	\N	Prestado	1	1
864	2026-01-20	2026-01-27	\N	Prestado	1	1
865	2026-01-20	2026-01-27	\N	Prestado	1	1
866	2026-01-20	2026-01-27	\N	Prestado	1	1
867	2026-01-20	2026-01-27	\N	Prestado	1	1
868	2026-01-20	2026-01-27	\N	Prestado	1	1
869	2026-01-20	2026-01-27	\N	Prestado	1	1
870	2026-01-20	2026-01-27	\N	Prestado	1	1
871	2026-01-20	2026-01-27	\N	Prestado	1	1
872	2026-01-20	2026-01-27	\N	Prestado	1	1
873	2026-01-20	2026-01-27	\N	Prestado	1	1
874	2026-01-20	2026-01-27	\N	Prestado	1	1
875	2026-01-20	2026-01-27	\N	Prestado	1	1
876	2026-01-20	2026-01-27	\N	Prestado	1	1
877	2026-01-20	2026-01-27	\N	Prestado	1	1
878	2026-01-20	2026-01-27	\N	Prestado	1	1
879	2026-01-20	2026-01-27	\N	Prestado	1	1
880	2026-01-20	2026-01-27	\N	Prestado	1	1
881	2026-01-20	2026-01-27	\N	Prestado	1	1
882	2026-01-20	2026-01-27	\N	Prestado	1	1
883	2026-01-20	2026-01-27	\N	Prestado	1	1
884	2026-01-20	2026-01-27	\N	Prestado	1	1
885	2026-01-20	2026-01-27	\N	Prestado	1	1
886	2026-01-20	2026-01-27	\N	Prestado	1	1
887	2026-01-20	2026-01-27	\N	Prestado	1	1
888	2026-01-20	2026-01-27	\N	Prestado	1	1
889	2026-01-20	2026-01-27	\N	Prestado	1	1
890	2026-01-20	2026-01-27	\N	Prestado	1	1
891	2026-01-20	2026-01-27	\N	Prestado	1	1
892	2026-01-20	2026-01-27	\N	Prestado	1	1
893	2026-01-20	2026-01-27	\N	Prestado	1	1
894	2026-01-20	2026-01-27	\N	Prestado	1	1
895	2026-01-20	2026-01-27	\N	Prestado	1	1
896	2026-01-20	2026-01-27	\N	Prestado	1	1
897	2026-01-20	2026-01-27	\N	Prestado	1	1
898	2026-01-20	2026-01-27	\N	Prestado	1	1
899	2026-01-20	2026-01-27	\N	Prestado	1	1
900	2026-01-20	2026-01-27	\N	Prestado	1	1
901	2026-01-20	2026-01-27	\N	Prestado	1	1
902	2026-01-20	2026-01-27	\N	Prestado	1	1
903	2026-01-20	2026-01-27	\N	Prestado	1	1
904	2026-01-20	2026-01-27	\N	Prestado	1	1
905	2026-01-20	2026-01-27	\N	Prestado	1	1
906	2026-01-20	2026-01-27	\N	Prestado	1	1
907	2026-01-20	2026-01-27	\N	Prestado	1	1
908	2026-01-20	2026-01-27	\N	Prestado	1	1
909	2026-01-20	2026-01-27	\N	Prestado	1	1
910	2026-01-20	2026-01-27	\N	Prestado	1	1
911	2026-01-20	2026-01-27	\N	Prestado	1	1
912	2026-01-20	2026-01-27	\N	Prestado	1	1
913	2026-01-20	2026-01-27	\N	Prestado	1	1
914	2026-01-20	2026-01-27	\N	Prestado	1	1
915	2026-01-20	2026-01-27	\N	Prestado	1	1
916	2026-01-20	2026-01-27	\N	Prestado	1	1
917	2026-01-20	2026-01-27	\N	Prestado	1	1
918	2026-01-20	2026-01-27	\N	Prestado	1	1
919	2026-01-20	2026-01-27	\N	Prestado	1	1
920	2026-01-20	2026-01-27	\N	Prestado	1	1
921	2026-01-20	2026-01-27	\N	Prestado	1	1
922	2026-01-20	2026-01-27	\N	Prestado	1	1
923	2026-01-20	2026-01-27	\N	Prestado	1	1
924	2026-01-20	2026-01-27	\N	Prestado	1	1
925	2026-01-20	2026-01-27	\N	Prestado	1	1
926	2026-01-20	2026-01-27	\N	Prestado	1	1
927	2026-01-20	2026-01-27	\N	Prestado	1	1
928	2026-01-20	2026-01-27	\N	Prestado	1	1
929	2026-01-20	2026-01-27	\N	Prestado	1	1
930	2026-01-20	2026-01-27	\N	Prestado	1	1
931	2026-01-20	2026-01-27	\N	Prestado	1	1
932	2026-01-20	2026-01-27	\N	Prestado	1	1
933	2026-01-20	2026-01-27	\N	Prestado	1	1
934	2026-01-20	2026-01-27	\N	Prestado	1	1
935	2026-01-20	2026-01-27	\N	Prestado	1	1
936	2026-01-20	2026-01-27	\N	Prestado	1	1
937	2026-01-20	2026-01-27	\N	Prestado	1	1
938	2026-01-20	2026-01-27	\N	Prestado	1	1
939	2026-01-20	2026-01-27	\N	Prestado	1	1
940	2026-01-20	2026-01-27	\N	Prestado	1	1
941	2026-01-20	2026-01-27	\N	Prestado	1	1
942	2026-01-20	2026-01-27	\N	Prestado	1	1
943	2026-01-20	2026-01-27	\N	Prestado	1	1
944	2026-01-20	2026-01-27	\N	Prestado	1	1
945	2026-01-20	2026-01-27	\N	Prestado	1	1
946	2026-01-20	2026-01-27	\N	Prestado	1	1
947	2026-01-20	2026-01-27	\N	Prestado	1	1
948	2026-01-20	2026-01-27	\N	Prestado	1	1
949	2026-01-20	2026-01-27	\N	Prestado	1	1
950	2026-01-20	2026-01-27	\N	Prestado	1	1
951	2026-01-20	2026-01-27	\N	Prestado	1	1
952	2026-01-20	2026-01-27	\N	Prestado	1	1
953	2026-01-20	2026-01-27	\N	Prestado	1	1
954	2026-01-20	2026-01-27	\N	Prestado	1	1
955	2026-01-20	2026-01-27	\N	Prestado	1	1
956	2026-01-20	2026-01-27	\N	Prestado	1	1
957	2026-01-20	2026-01-27	\N	Prestado	1	1
958	2026-01-20	2026-01-27	\N	Prestado	1	1
959	2026-01-20	2026-01-27	\N	Prestado	1	1
960	2026-01-20	2026-01-27	\N	Prestado	1	1
961	2026-01-20	2026-01-27	\N	Prestado	1	1
962	2026-01-20	2026-01-27	\N	Prestado	1	1
963	2026-01-20	2026-01-27	\N	Prestado	1	1
964	2026-01-20	2026-01-27	\N	Prestado	1	1
965	2026-01-20	2026-01-27	\N	Prestado	1	1
966	2026-01-20	2026-01-27	\N	Prestado	1	1
967	2026-01-20	2026-01-27	\N	Prestado	1	1
968	2026-01-20	2026-01-27	\N	Prestado	1	1
969	2026-01-20	2026-01-27	\N	Prestado	1	1
970	2026-01-20	2026-01-27	\N	Prestado	1	1
971	2026-01-20	2026-01-27	\N	Prestado	1	1
972	2026-01-20	2026-01-27	\N	Prestado	1	1
973	2026-01-20	2026-01-27	\N	Prestado	1	1
974	2026-01-20	2026-01-27	\N	Prestado	1	1
975	2026-01-20	2026-01-27	\N	Prestado	1	1
976	2026-01-20	2026-01-27	\N	Prestado	1	1
977	2026-01-20	2026-01-27	\N	Prestado	1	1
978	2026-01-20	2026-01-27	\N	Prestado	1	1
979	2026-01-20	2026-01-27	\N	Prestado	1	1
980	2026-01-20	2026-01-27	\N	Prestado	1	1
981	2026-01-20	2026-01-27	\N	Prestado	1	1
982	2026-01-20	2026-01-27	\N	Prestado	1	1
983	2026-01-20	2026-01-27	\N	Prestado	1	1
984	2026-01-20	2026-01-27	\N	Prestado	1	1
985	2026-01-20	2026-01-27	\N	Prestado	1	1
986	2026-01-20	2026-01-27	\N	Prestado	1	1
987	2026-01-20	2026-01-27	\N	Prestado	1	1
988	2026-01-20	2026-01-27	\N	Prestado	1	1
989	2026-01-20	2026-01-27	\N	Prestado	1	1
990	2026-01-20	2026-01-27	\N	Prestado	1	1
991	2026-01-20	2026-01-27	\N	Prestado	1	1
992	2026-01-20	2026-01-27	\N	Prestado	1	1
993	2026-01-20	2026-01-27	\N	Prestado	1	1
994	2026-01-20	2026-01-27	\N	Prestado	1	1
995	2026-01-20	2026-01-27	\N	Prestado	1	1
996	2026-01-20	2026-01-27	\N	Prestado	1	1
997	2026-01-20	2026-01-27	\N	Prestado	1	1
998	2026-01-20	2026-01-27	\N	Prestado	1	1
999	2026-01-20	2026-01-27	\N	Prestado	1	1
1000	2026-01-20	2026-01-27	\N	Prestado	1	1
1001	2026-01-20	2026-01-27	\N	Prestado	1	1
1002	2026-01-20	2026-01-27	\N	Prestado	1	1
1003	2026-01-20	2026-01-27	\N	Prestado	1	1
3	2026-01-20	2026-01-15	\N	Devuelto	3	3
4	2026-01-20	2026-01-27	\N	Devuelto	1	1
5	2026-01-20	2026-01-27	\N	Devuelto	1	1
6	2026-01-20	2026-01-27	\N	Devuelto	1	1
7	2026-01-20	2026-01-27	\N	Devuelto	1	1
8	2026-01-20	2026-01-27	\N	Devuelto	1	1
9	2026-01-20	2026-01-27	\N	Devuelto	1	1
10	2026-01-20	2026-01-27	\N	Devuelto	1	1
11	2026-01-20	2026-01-27	\N	Devuelto	1	1
12	2026-01-20	2026-01-27	\N	Devuelto	1	1
13	2026-01-20	2026-01-27	\N	Devuelto	1	1
14	2026-01-20	2026-01-27	\N	Devuelto	1	1
15	2026-01-20	2026-01-27	\N	Devuelto	1	1
16	2026-01-20	2026-01-27	\N	Devuelto	1	1
17	2026-01-20	2026-01-27	\N	Devuelto	1	1
18	2026-01-20	2026-01-27	\N	Devuelto	1	1
19	2026-01-20	2026-01-27	\N	Devuelto	1	1
20	2026-01-20	2026-01-27	\N	Devuelto	1	1
21	2026-01-20	2026-01-27	\N	Devuelto	1	1
22	2026-01-20	2026-01-27	\N	Devuelto	1	1
23	2026-01-20	2026-01-27	\N	Devuelto	1	1
24	2026-01-20	2026-01-27	\N	Devuelto	1	1
25	2026-01-20	2026-01-27	\N	Devuelto	1	1
26	2026-01-20	2026-01-27	\N	Devuelto	1	1
27	2026-01-20	2026-01-27	\N	Devuelto	1	1
28	2026-01-20	2026-01-27	\N	Devuelto	1	1
29	2026-01-20	2026-01-27	\N	Devuelto	1	1
30	2026-01-20	2026-01-27	\N	Devuelto	1	1
31	2026-01-20	2026-01-27	\N	Devuelto	1	1
32	2026-01-20	2026-01-27	\N	Devuelto	1	1
33	2026-01-20	2026-01-27	\N	Devuelto	1	1
34	2026-01-20	2026-01-27	\N	Devuelto	1	1
35	2026-01-20	2026-01-27	\N	Devuelto	1	1
36	2026-01-20	2026-01-27	\N	Devuelto	1	1
37	2026-01-20	2026-01-27	\N	Devuelto	1	1
38	2026-01-20	2026-01-27	\N	Devuelto	1	1
39	2026-01-20	2026-01-27	\N	Devuelto	1	1
40	2026-01-20	2026-01-27	\N	Devuelto	1	1
41	2026-01-20	2026-01-27	\N	Devuelto	1	1
42	2026-01-20	2026-01-27	\N	Devuelto	1	1
43	2026-01-20	2026-01-27	\N	Devuelto	1	1
44	2026-01-20	2026-01-27	\N	Devuelto	1	1
45	2026-01-20	2026-01-27	\N	Devuelto	1	1
46	2026-01-20	2026-01-27	\N	Devuelto	1	1
47	2026-01-20	2026-01-27	\N	Devuelto	1	1
48	2026-01-20	2026-01-27	\N	Devuelto	1	1
49	2026-01-20	2026-01-27	\N	Devuelto	1	1
50	2026-01-20	2026-01-27	\N	Devuelto	1	1
51	2026-01-20	2026-01-27	\N	Devuelto	1	1
52	2026-01-20	2026-01-27	\N	Devuelto	1	1
53	2026-01-20	2026-01-27	\N	Devuelto	1	1
54	2026-01-20	2026-01-27	\N	Devuelto	1	1
55	2026-01-20	2026-01-27	\N	Devuelto	1	1
56	2026-01-20	2026-01-27	\N	Devuelto	1	1
57	2026-01-20	2026-01-27	\N	Devuelto	1	1
58	2026-01-20	2026-01-27	\N	Devuelto	1	1
59	2026-01-20	2026-01-27	\N	Devuelto	1	1
60	2026-01-20	2026-01-27	\N	Devuelto	1	1
61	2026-01-20	2026-01-27	\N	Devuelto	1	1
62	2026-01-20	2026-01-27	\N	Devuelto	1	1
63	2026-01-20	2026-01-27	\N	Devuelto	1	1
64	2026-01-20	2026-01-27	\N	Devuelto	1	1
65	2026-01-20	2026-01-27	\N	Devuelto	1	1
66	2026-01-20	2026-01-27	\N	Devuelto	1	1
67	2026-01-20	2026-01-27	\N	Devuelto	1	1
68	2026-01-20	2026-01-27	\N	Devuelto	1	1
69	2026-01-20	2026-01-27	\N	Devuelto	1	1
70	2026-01-20	2026-01-27	\N	Devuelto	1	1
71	2026-01-20	2026-01-27	\N	Devuelto	1	1
72	2026-01-20	2026-01-27	\N	Devuelto	1	1
73	2026-01-20	2026-01-27	\N	Devuelto	1	1
74	2026-01-20	2026-01-27	\N	Devuelto	1	1
75	2026-01-20	2026-01-27	\N	Devuelto	1	1
76	2026-01-20	2026-01-27	\N	Devuelto	1	1
77	2026-01-20	2026-01-27	\N	Devuelto	1	1
78	2026-01-20	2026-01-27	\N	Devuelto	1	1
79	2026-01-20	2026-01-27	\N	Devuelto	1	1
80	2026-01-20	2026-01-27	\N	Devuelto	1	1
81	2026-01-20	2026-01-27	\N	Devuelto	1	1
82	2026-01-20	2026-01-27	\N	Devuelto	1	1
83	2026-01-20	2026-01-27	\N	Devuelto	1	1
84	2026-01-20	2026-01-27	\N	Devuelto	1	1
85	2026-01-20	2026-01-27	\N	Devuelto	1	1
86	2026-01-20	2026-01-27	\N	Devuelto	1	1
87	2026-01-20	2026-01-27	\N	Devuelto	1	1
88	2026-01-20	2026-01-27	\N	Devuelto	1	1
89	2026-01-20	2026-01-27	\N	Devuelto	1	1
90	2026-01-20	2026-01-27	\N	Devuelto	1	1
91	2026-01-20	2026-01-27	\N	Devuelto	1	1
92	2026-01-20	2026-01-27	\N	Devuelto	1	1
93	2026-01-20	2026-01-27	\N	Devuelto	1	1
94	2026-01-20	2026-01-27	\N	Devuelto	1	1
95	2026-01-20	2026-01-27	\N	Devuelto	1	1
96	2026-01-20	2026-01-27	\N	Devuelto	1	1
97	2026-01-20	2026-01-27	\N	Devuelto	1	1
98	2026-01-20	2026-01-27	\N	Devuelto	1	1
99	2026-01-20	2026-01-27	\N	Devuelto	1	1
100	2026-01-20	2026-01-27	\N	Devuelto	1	1
101	2026-01-20	2026-01-27	\N	Devuelto	1	1
102	2026-01-20	2026-01-27	\N	Devuelto	1	1
103	2026-01-20	2026-01-27	\N	Devuelto	1	1
104	2026-01-20	2026-01-27	\N	Devuelto	1	1
105	2026-01-20	2026-01-27	\N	Devuelto	1	1
106	2026-01-20	2026-01-27	\N	Devuelto	1	1
107	2026-01-20	2026-01-27	\N	Devuelto	1	1
108	2026-01-20	2026-01-27	\N	Devuelto	1	1
109	2026-01-20	2026-01-27	\N	Devuelto	1	1
110	2026-01-20	2026-01-27	\N	Devuelto	1	1
111	2026-01-20	2026-01-27	\N	Devuelto	1	1
112	2026-01-20	2026-01-27	\N	Devuelto	1	1
113	2026-01-20	2026-01-27	\N	Devuelto	1	1
114	2026-01-20	2026-01-27	\N	Devuelto	1	1
115	2026-01-20	2026-01-27	\N	Devuelto	1	1
116	2026-01-20	2026-01-27	\N	Devuelto	1	1
117	2026-01-20	2026-01-27	\N	Devuelto	1	1
118	2026-01-20	2026-01-27	\N	Devuelto	1	1
119	2026-01-20	2026-01-27	\N	Devuelto	1	1
120	2026-01-20	2026-01-27	\N	Devuelto	1	1
121	2026-01-20	2026-01-27	\N	Devuelto	1	1
122	2026-01-20	2026-01-27	\N	Devuelto	1	1
123	2026-01-20	2026-01-27	\N	Devuelto	1	1
124	2026-01-20	2026-01-27	\N	Devuelto	1	1
125	2026-01-20	2026-01-27	\N	Devuelto	1	1
126	2026-01-20	2026-01-27	\N	Devuelto	1	1
127	2026-01-20	2026-01-27	\N	Devuelto	1	1
128	2026-01-20	2026-01-27	\N	Devuelto	1	1
129	2026-01-20	2026-01-27	\N	Devuelto	1	1
130	2026-01-20	2026-01-27	\N	Devuelto	1	1
131	2026-01-20	2026-01-27	\N	Devuelto	1	1
132	2026-01-20	2026-01-27	\N	Devuelto	1	1
133	2026-01-20	2026-01-27	\N	Devuelto	1	1
134	2026-01-20	2026-01-27	\N	Devuelto	1	1
135	2026-01-20	2026-01-27	\N	Devuelto	1	1
136	2026-01-20	2026-01-27	\N	Devuelto	1	1
137	2026-01-20	2026-01-27	\N	Devuelto	1	1
138	2026-01-20	2026-01-27	\N	Devuelto	1	1
139	2026-01-20	2026-01-27	\N	Devuelto	1	1
140	2026-01-20	2026-01-27	\N	Devuelto	1	1
141	2026-01-20	2026-01-27	\N	Devuelto	1	1
142	2026-01-20	2026-01-27	\N	Devuelto	1	1
143	2026-01-20	2026-01-27	\N	Devuelto	1	1
144	2026-01-20	2026-01-27	\N	Devuelto	1	1
145	2026-01-20	2026-01-27	\N	Devuelto	1	1
146	2026-01-20	2026-01-27	\N	Devuelto	1	1
147	2026-01-20	2026-01-27	\N	Devuelto	1	1
148	2026-01-20	2026-01-27	\N	Devuelto	1	1
149	2026-01-20	2026-01-27	\N	Devuelto	1	1
150	2026-01-20	2026-01-27	\N	Devuelto	1	1
151	2026-01-20	2026-01-27	\N	Devuelto	1	1
152	2026-01-20	2026-01-27	\N	Devuelto	1	1
153	2026-01-20	2026-01-27	\N	Devuelto	1	1
154	2026-01-20	2026-01-27	\N	Devuelto	1	1
155	2026-01-20	2026-01-27	\N	Devuelto	1	1
156	2026-01-20	2026-01-27	\N	Devuelto	1	1
157	2026-01-20	2026-01-27	\N	Devuelto	1	1
158	2026-01-20	2026-01-27	\N	Devuelto	1	1
159	2026-01-20	2026-01-27	\N	Devuelto	1	1
160	2026-01-20	2026-01-27	\N	Devuelto	1	1
161	2026-01-20	2026-01-27	\N	Devuelto	1	1
162	2026-01-20	2026-01-27	\N	Devuelto	1	1
163	2026-01-20	2026-01-27	\N	Devuelto	1	1
164	2026-01-20	2026-01-27	\N	Devuelto	1	1
165	2026-01-20	2026-01-27	\N	Devuelto	1	1
166	2026-01-20	2026-01-27	\N	Devuelto	1	1
167	2026-01-20	2026-01-27	\N	Devuelto	1	1
168	2026-01-20	2026-01-27	\N	Devuelto	1	1
169	2026-01-20	2026-01-27	\N	Devuelto	1	1
170	2026-01-20	2026-01-27	\N	Devuelto	1	1
171	2026-01-20	2026-01-27	\N	Devuelto	1	1
172	2026-01-20	2026-01-27	\N	Devuelto	1	1
173	2026-01-20	2026-01-27	\N	Devuelto	1	1
174	2026-01-20	2026-01-27	\N	Devuelto	1	1
175	2026-01-20	2026-01-27	\N	Devuelto	1	1
176	2026-01-20	2026-01-27	\N	Devuelto	1	1
177	2026-01-20	2026-01-27	\N	Devuelto	1	1
178	2026-01-20	2026-01-27	\N	Devuelto	1	1
179	2026-01-20	2026-01-27	\N	Devuelto	1	1
180	2026-01-20	2026-01-27	\N	Devuelto	1	1
181	2026-01-20	2026-01-27	\N	Devuelto	1	1
182	2026-01-20	2026-01-27	\N	Devuelto	1	1
183	2026-01-20	2026-01-27	\N	Devuelto	1	1
184	2026-01-20	2026-01-27	\N	Devuelto	1	1
185	2026-01-20	2026-01-27	\N	Devuelto	1	1
186	2026-01-20	2026-01-27	\N	Devuelto	1	1
187	2026-01-20	2026-01-27	\N	Devuelto	1	1
188	2026-01-20	2026-01-27	\N	Devuelto	1	1
189	2026-01-20	2026-01-27	\N	Devuelto	1	1
190	2026-01-20	2026-01-27	\N	Devuelto	1	1
191	2026-01-20	2026-01-27	\N	Devuelto	1	1
192	2026-01-20	2026-01-27	\N	Devuelto	1	1
193	2026-01-20	2026-01-27	\N	Devuelto	1	1
194	2026-01-20	2026-01-27	\N	Devuelto	1	1
195	2026-01-20	2026-01-27	\N	Devuelto	1	1
196	2026-01-20	2026-01-27	\N	Devuelto	1	1
197	2026-01-20	2026-01-27	\N	Devuelto	1	1
198	2026-01-20	2026-01-27	\N	Devuelto	1	1
199	2026-01-20	2026-01-27	\N	Devuelto	1	1
200	2026-01-20	2026-01-27	\N	Devuelto	1	1
201	2026-01-20	2026-01-27	\N	Devuelto	1	1
202	2026-01-20	2026-01-27	\N	Devuelto	1	1
203	2026-01-20	2026-01-27	\N	Devuelto	1	1
204	2026-01-20	2026-01-27	\N	Devuelto	1	1
205	2026-01-20	2026-01-27	\N	Devuelto	1	1
206	2026-01-20	2026-01-27	\N	Devuelto	1	1
207	2026-01-20	2026-01-27	\N	Devuelto	1	1
208	2026-01-20	2026-01-27	\N	Devuelto	1	1
209	2026-01-20	2026-01-27	\N	Devuelto	1	1
210	2026-01-20	2026-01-27	\N	Devuelto	1	1
211	2026-01-20	2026-01-27	\N	Devuelto	1	1
212	2026-01-20	2026-01-27	\N	Devuelto	1	1
213	2026-01-20	2026-01-27	\N	Devuelto	1	1
214	2026-01-20	2026-01-27	\N	Devuelto	1	1
215	2026-01-20	2026-01-27	\N	Devuelto	1	1
216	2026-01-20	2026-01-27	\N	Devuelto	1	1
217	2026-01-20	2026-01-27	\N	Devuelto	1	1
218	2026-01-20	2026-01-27	\N	Devuelto	1	1
219	2026-01-20	2026-01-27	\N	Devuelto	1	1
220	2026-01-20	2026-01-27	\N	Devuelto	1	1
221	2026-01-20	2026-01-27	\N	Devuelto	1	1
222	2026-01-20	2026-01-27	\N	Devuelto	1	1
223	2026-01-20	2026-01-27	\N	Devuelto	1	1
224	2026-01-20	2026-01-27	\N	Devuelto	1	1
225	2026-01-20	2026-01-27	\N	Devuelto	1	1
226	2026-01-20	2026-01-27	\N	Devuelto	1	1
227	2026-01-20	2026-01-27	\N	Devuelto	1	1
228	2026-01-20	2026-01-27	\N	Devuelto	1	1
229	2026-01-20	2026-01-27	\N	Devuelto	1	1
230	2026-01-20	2026-01-27	\N	Devuelto	1	1
231	2026-01-20	2026-01-27	\N	Devuelto	1	1
232	2026-01-20	2026-01-27	\N	Devuelto	1	1
233	2026-01-20	2026-01-27	\N	Devuelto	1	1
234	2026-01-20	2026-01-27	\N	Devuelto	1	1
235	2026-01-20	2026-01-27	\N	Devuelto	1	1
236	2026-01-20	2026-01-27	\N	Devuelto	1	1
237	2026-01-20	2026-01-27	\N	Devuelto	1	1
238	2026-01-20	2026-01-27	\N	Devuelto	1	1
239	2026-01-20	2026-01-27	\N	Devuelto	1	1
240	2026-01-20	2026-01-27	\N	Devuelto	1	1
241	2026-01-20	2026-01-27	\N	Devuelto	1	1
242	2026-01-20	2026-01-27	\N	Devuelto	1	1
243	2026-01-20	2026-01-27	\N	Devuelto	1	1
244	2026-01-20	2026-01-27	\N	Devuelto	1	1
245	2026-01-20	2026-01-27	\N	Devuelto	1	1
246	2026-01-20	2026-01-27	\N	Devuelto	1	1
247	2026-01-20	2026-01-27	\N	Devuelto	1	1
248	2026-01-20	2026-01-27	\N	Devuelto	1	1
249	2026-01-20	2026-01-27	\N	Devuelto	1	1
250	2026-01-20	2026-01-27	\N	Devuelto	1	1
251	2026-01-20	2026-01-27	\N	Devuelto	1	1
252	2026-01-20	2026-01-27	\N	Devuelto	1	1
253	2026-01-20	2026-01-27	\N	Devuelto	1	1
254	2026-01-20	2026-01-27	\N	Devuelto	1	1
255	2026-01-20	2026-01-27	\N	Devuelto	1	1
256	2026-01-20	2026-01-27	\N	Devuelto	1	1
257	2026-01-20	2026-01-27	\N	Devuelto	1	1
258	2026-01-20	2026-01-27	\N	Devuelto	1	1
259	2026-01-20	2026-01-27	\N	Devuelto	1	1
260	2026-01-20	2026-01-27	\N	Devuelto	1	1
261	2026-01-20	2026-01-27	\N	Devuelto	1	1
262	2026-01-20	2026-01-27	\N	Devuelto	1	1
263	2026-01-20	2026-01-27	\N	Devuelto	1	1
264	2026-01-20	2026-01-27	\N	Devuelto	1	1
265	2026-01-20	2026-01-27	\N	Devuelto	1	1
266	2026-01-20	2026-01-27	\N	Devuelto	1	1
267	2026-01-20	2026-01-27	\N	Devuelto	1	1
268	2026-01-20	2026-01-27	\N	Devuelto	1	1
269	2026-01-20	2026-01-27	\N	Devuelto	1	1
270	2026-01-20	2026-01-27	\N	Devuelto	1	1
271	2026-01-20	2026-01-27	\N	Devuelto	1	1
272	2026-01-20	2026-01-27	\N	Devuelto	1	1
273	2026-01-20	2026-01-27	\N	Devuelto	1	1
274	2026-01-20	2026-01-27	\N	Devuelto	1	1
275	2026-01-20	2026-01-27	\N	Devuelto	1	1
276	2026-01-20	2026-01-27	\N	Devuelto	1	1
277	2026-01-20	2026-01-27	\N	Devuelto	1	1
278	2026-01-20	2026-01-27	\N	Devuelto	1	1
279	2026-01-20	2026-01-27	\N	Devuelto	1	1
280	2026-01-20	2026-01-27	\N	Devuelto	1	1
281	2026-01-20	2026-01-27	\N	Devuelto	1	1
282	2026-01-20	2026-01-27	\N	Devuelto	1	1
283	2026-01-20	2026-01-27	\N	Devuelto	1	1
284	2026-01-20	2026-01-27	\N	Devuelto	1	1
285	2026-01-20	2026-01-27	\N	Devuelto	1	1
286	2026-01-20	2026-01-27	\N	Devuelto	1	1
287	2026-01-20	2026-01-27	\N	Devuelto	1	1
288	2026-01-20	2026-01-27	\N	Devuelto	1	1
289	2026-01-20	2026-01-27	\N	Devuelto	1	1
290	2026-01-20	2026-01-27	\N	Devuelto	1	1
291	2026-01-20	2026-01-27	\N	Devuelto	1	1
292	2026-01-20	2026-01-27	\N	Devuelto	1	1
293	2026-01-20	2026-01-27	\N	Devuelto	1	1
294	2026-01-20	2026-01-27	\N	Devuelto	1	1
295	2026-01-20	2026-01-27	\N	Devuelto	1	1
296	2026-01-20	2026-01-27	\N	Devuelto	1	1
297	2026-01-20	2026-01-27	\N	Devuelto	1	1
298	2026-01-20	2026-01-27	\N	Devuelto	1	1
299	2026-01-20	2026-01-27	\N	Devuelto	1	1
300	2026-01-20	2026-01-27	\N	Devuelto	1	1
301	2026-01-20	2026-01-27	\N	Devuelto	1	1
302	2026-01-20	2026-01-27	\N	Devuelto	1	1
303	2026-01-20	2026-01-27	\N	Devuelto	1	1
304	2026-01-20	2026-01-27	\N	Devuelto	1	1
305	2026-01-20	2026-01-27	\N	Devuelto	1	1
306	2026-01-20	2026-01-27	\N	Devuelto	1	1
307	2026-01-20	2026-01-27	\N	Devuelto	1	1
308	2026-01-20	2026-01-27	\N	Devuelto	1	1
309	2026-01-20	2026-01-27	\N	Devuelto	1	1
310	2026-01-20	2026-01-27	\N	Devuelto	1	1
311	2026-01-20	2026-01-27	\N	Devuelto	1	1
312	2026-01-20	2026-01-27	\N	Devuelto	1	1
313	2026-01-20	2026-01-27	\N	Devuelto	1	1
314	2026-01-20	2026-01-27	\N	Devuelto	1	1
315	2026-01-20	2026-01-27	\N	Devuelto	1	1
316	2026-01-20	2026-01-27	\N	Devuelto	1	1
317	2026-01-20	2026-01-27	\N	Devuelto	1	1
318	2026-01-20	2026-01-27	\N	Devuelto	1	1
319	2026-01-20	2026-01-27	\N	Devuelto	1	1
320	2026-01-20	2026-01-27	\N	Devuelto	1	1
321	2026-01-20	2026-01-27	\N	Devuelto	1	1
322	2026-01-20	2026-01-27	\N	Devuelto	1	1
323	2026-01-20	2026-01-27	\N	Devuelto	1	1
324	2026-01-20	2026-01-27	\N	Devuelto	1	1
325	2026-01-20	2026-01-27	\N	Devuelto	1	1
326	2026-01-20	2026-01-27	\N	Devuelto	1	1
327	2026-01-20	2026-01-27	\N	Devuelto	1	1
328	2026-01-20	2026-01-27	\N	Devuelto	1	1
329	2026-01-20	2026-01-27	\N	Devuelto	1	1
330	2026-01-20	2026-01-27	\N	Devuelto	1	1
331	2026-01-20	2026-01-27	\N	Devuelto	1	1
332	2026-01-20	2026-01-27	\N	Devuelto	1	1
333	2026-01-20	2026-01-27	\N	Devuelto	1	1
334	2026-01-20	2026-01-27	\N	Devuelto	1	1
335	2026-01-20	2026-01-27	\N	Devuelto	1	1
336	2026-01-20	2026-01-27	\N	Devuelto	1	1
337	2026-01-20	2026-01-27	\N	Devuelto	1	1
338	2026-01-20	2026-01-27	\N	Devuelto	1	1
339	2026-01-20	2026-01-27	\N	Devuelto	1	1
340	2026-01-20	2026-01-27	\N	Devuelto	1	1
341	2026-01-20	2026-01-27	\N	Devuelto	1	1
342	2026-01-20	2026-01-27	\N	Devuelto	1	1
343	2026-01-20	2026-01-27	\N	Devuelto	1	1
344	2026-01-20	2026-01-27	\N	Devuelto	1	1
345	2026-01-20	2026-01-27	\N	Devuelto	1	1
346	2026-01-20	2026-01-27	\N	Devuelto	1	1
347	2026-01-20	2026-01-27	\N	Devuelto	1	1
348	2026-01-20	2026-01-27	\N	Devuelto	1	1
349	2026-01-20	2026-01-27	\N	Devuelto	1	1
350	2026-01-20	2026-01-27	\N	Devuelto	1	1
351	2026-01-20	2026-01-27	\N	Devuelto	1	1
352	2026-01-20	2026-01-27	\N	Devuelto	1	1
353	2026-01-20	2026-01-27	\N	Devuelto	1	1
354	2026-01-20	2026-01-27	\N	Devuelto	1	1
355	2026-01-20	2026-01-27	\N	Devuelto	1	1
356	2026-01-20	2026-01-27	\N	Devuelto	1	1
357	2026-01-20	2026-01-27	\N	Devuelto	1	1
358	2026-01-20	2026-01-27	\N	Devuelto	1	1
359	2026-01-20	2026-01-27	\N	Devuelto	1	1
360	2026-01-20	2026-01-27	\N	Devuelto	1	1
361	2026-01-20	2026-01-27	\N	Devuelto	1	1
362	2026-01-20	2026-01-27	\N	Devuelto	1	1
363	2026-01-20	2026-01-27	\N	Devuelto	1	1
364	2026-01-20	2026-01-27	\N	Devuelto	1	1
365	2026-01-20	2026-01-27	\N	Devuelto	1	1
366	2026-01-20	2026-01-27	\N	Devuelto	1	1
367	2026-01-20	2026-01-27	\N	Devuelto	1	1
368	2026-01-20	2026-01-27	\N	Devuelto	1	1
369	2026-01-20	2026-01-27	\N	Devuelto	1	1
370	2026-01-20	2026-01-27	\N	Devuelto	1	1
371	2026-01-20	2026-01-27	\N	Devuelto	1	1
372	2026-01-20	2026-01-27	\N	Devuelto	1	1
373	2026-01-20	2026-01-27	\N	Devuelto	1	1
374	2026-01-20	2026-01-27	\N	Devuelto	1	1
375	2026-01-20	2026-01-27	\N	Devuelto	1	1
376	2026-01-20	2026-01-27	\N	Devuelto	1	1
377	2026-01-20	2026-01-27	\N	Devuelto	1	1
378	2026-01-20	2026-01-27	\N	Devuelto	1	1
379	2026-01-20	2026-01-27	\N	Devuelto	1	1
380	2026-01-20	2026-01-27	\N	Devuelto	1	1
381	2026-01-20	2026-01-27	\N	Devuelto	1	1
382	2026-01-20	2026-01-27	\N	Devuelto	1	1
383	2026-01-20	2026-01-27	\N	Devuelto	1	1
384	2026-01-20	2026-01-27	\N	Devuelto	1	1
385	2026-01-20	2026-01-27	\N	Devuelto	1	1
386	2026-01-20	2026-01-27	\N	Devuelto	1	1
387	2026-01-20	2026-01-27	\N	Devuelto	1	1
388	2026-01-20	2026-01-27	\N	Devuelto	1	1
389	2026-01-20	2026-01-27	\N	Devuelto	1	1
390	2026-01-20	2026-01-27	\N	Devuelto	1	1
391	2026-01-20	2026-01-27	\N	Devuelto	1	1
392	2026-01-20	2026-01-27	\N	Devuelto	1	1
393	2026-01-20	2026-01-27	\N	Devuelto	1	1
394	2026-01-20	2026-01-27	\N	Devuelto	1	1
395	2026-01-20	2026-01-27	\N	Devuelto	1	1
396	2026-01-20	2026-01-27	\N	Devuelto	1	1
397	2026-01-20	2026-01-27	\N	Devuelto	1	1
398	2026-01-20	2026-01-27	\N	Devuelto	1	1
399	2026-01-20	2026-01-27	\N	Devuelto	1	1
400	2026-01-20	2026-01-27	\N	Devuelto	1	1
401	2026-01-20	2026-01-27	\N	Devuelto	1	1
402	2026-01-20	2026-01-27	\N	Devuelto	1	1
403	2026-01-20	2026-01-27	\N	Devuelto	1	1
404	2026-01-20	2026-01-27	\N	Devuelto	1	1
405	2026-01-20	2026-01-27	\N	Devuelto	1	1
406	2026-01-20	2026-01-27	\N	Devuelto	1	1
407	2026-01-20	2026-01-27	\N	Devuelto	1	1
408	2026-01-20	2026-01-27	\N	Devuelto	1	1
409	2026-01-20	2026-01-27	\N	Devuelto	1	1
410	2026-01-20	2026-01-27	\N	Devuelto	1	1
411	2026-01-20	2026-01-27	\N	Devuelto	1	1
412	2026-01-20	2026-01-27	\N	Devuelto	1	1
413	2026-01-20	2026-01-27	\N	Devuelto	1	1
414	2026-01-20	2026-01-27	\N	Devuelto	1	1
415	2026-01-20	2026-01-27	\N	Devuelto	1	1
416	2026-01-20	2026-01-27	\N	Devuelto	1	1
417	2026-01-20	2026-01-27	\N	Devuelto	1	1
418	2026-01-20	2026-01-27	\N	Devuelto	1	1
419	2026-01-20	2026-01-27	\N	Devuelto	1	1
420	2026-01-20	2026-01-27	\N	Devuelto	1	1
421	2026-01-20	2026-01-27	\N	Devuelto	1	1
422	2026-01-20	2026-01-27	\N	Devuelto	1	1
423	2026-01-20	2026-01-27	\N	Devuelto	1	1
424	2026-01-20	2026-01-27	\N	Devuelto	1	1
425	2026-01-20	2026-01-27	\N	Devuelto	1	1
426	2026-01-20	2026-01-27	\N	Devuelto	1	1
427	2026-01-20	2026-01-27	\N	Devuelto	1	1
428	2026-01-20	2026-01-27	\N	Devuelto	1	1
429	2026-01-20	2026-01-27	\N	Devuelto	1	1
430	2026-01-20	2026-01-27	\N	Devuelto	1	1
431	2026-01-20	2026-01-27	\N	Devuelto	1	1
432	2026-01-20	2026-01-27	\N	Devuelto	1	1
433	2026-01-20	2026-01-27	\N	Devuelto	1	1
434	2026-01-20	2026-01-27	\N	Devuelto	1	1
435	2026-01-20	2026-01-27	\N	Devuelto	1	1
436	2026-01-20	2026-01-27	\N	Devuelto	1	1
437	2026-01-20	2026-01-27	\N	Devuelto	1	1
438	2026-01-20	2026-01-27	\N	Devuelto	1	1
439	2026-01-20	2026-01-27	\N	Devuelto	1	1
440	2026-01-20	2026-01-27	\N	Devuelto	1	1
441	2026-01-20	2026-01-27	\N	Devuelto	1	1
442	2026-01-20	2026-01-27	\N	Devuelto	1	1
443	2026-01-20	2026-01-27	\N	Devuelto	1	1
444	2026-01-20	2026-01-27	\N	Devuelto	1	1
445	2026-01-20	2026-01-27	\N	Devuelto	1	1
446	2026-01-20	2026-01-27	\N	Devuelto	1	1
447	2026-01-20	2026-01-27	\N	Devuelto	1	1
448	2026-01-20	2026-01-27	\N	Devuelto	1	1
449	2026-01-20	2026-01-27	\N	Devuelto	1	1
450	2026-01-20	2026-01-27	\N	Devuelto	1	1
451	2026-01-20	2026-01-27	\N	Devuelto	1	1
452	2026-01-20	2026-01-27	\N	Devuelto	1	1
453	2026-01-20	2026-01-27	\N	Devuelto	1	1
454	2026-01-20	2026-01-27	\N	Devuelto	1	1
455	2026-01-20	2026-01-27	\N	Devuelto	1	1
456	2026-01-20	2026-01-27	\N	Devuelto	1	1
457	2026-01-20	2026-01-27	\N	Devuelto	1	1
458	2026-01-20	2026-01-27	\N	Devuelto	1	1
459	2026-01-20	2026-01-27	\N	Devuelto	1	1
460	2026-01-20	2026-01-27	\N	Devuelto	1	1
461	2026-01-20	2026-01-27	\N	Devuelto	1	1
462	2026-01-20	2026-01-27	\N	Devuelto	1	1
463	2026-01-20	2026-01-27	\N	Devuelto	1	1
464	2026-01-20	2026-01-27	\N	Devuelto	1	1
465	2026-01-20	2026-01-27	\N	Devuelto	1	1
466	2026-01-20	2026-01-27	\N	Devuelto	1	1
467	2026-01-20	2026-01-27	\N	Devuelto	1	1
468	2026-01-20	2026-01-27	\N	Devuelto	1	1
469	2026-01-20	2026-01-27	\N	Devuelto	1	1
470	2026-01-20	2026-01-27	\N	Devuelto	1	1
471	2026-01-20	2026-01-27	\N	Devuelto	1	1
472	2026-01-20	2026-01-27	\N	Devuelto	1	1
473	2026-01-20	2026-01-27	\N	Devuelto	1	1
474	2026-01-20	2026-01-27	\N	Devuelto	1	1
475	2026-01-20	2026-01-27	\N	Devuelto	1	1
476	2026-01-20	2026-01-27	\N	Devuelto	1	1
477	2026-01-20	2026-01-27	\N	Devuelto	1	1
478	2026-01-20	2026-01-27	\N	Devuelto	1	1
479	2026-01-20	2026-01-27	\N	Devuelto	1	1
480	2026-01-20	2026-01-27	\N	Devuelto	1	1
481	2026-01-20	2026-01-27	\N	Devuelto	1	1
482	2026-01-20	2026-01-27	\N	Devuelto	1	1
483	2026-01-20	2026-01-27	\N	Devuelto	1	1
484	2026-01-20	2026-01-27	\N	Devuelto	1	1
485	2026-01-20	2026-01-27	\N	Devuelto	1	1
486	2026-01-20	2026-01-27	\N	Devuelto	1	1
487	2026-01-20	2026-01-27	\N	Devuelto	1	1
488	2026-01-20	2026-01-27	\N	Devuelto	1	1
489	2026-01-20	2026-01-27	\N	Devuelto	1	1
490	2026-01-20	2026-01-27	\N	Devuelto	1	1
491	2026-01-20	2026-01-27	\N	Devuelto	1	1
492	2026-01-20	2026-01-27	\N	Devuelto	1	1
493	2026-01-20	2026-01-27	\N	Devuelto	1	1
494	2026-01-20	2026-01-27	\N	Devuelto	1	1
495	2026-01-20	2026-01-27	\N	Devuelto	1	1
496	2026-01-20	2026-01-27	\N	Devuelto	1	1
497	2026-01-20	2026-01-27	\N	Devuelto	1	1
498	2026-01-20	2026-01-27	\N	Devuelto	1	1
499	2026-01-20	2026-01-27	\N	Devuelto	1	1
500	2026-01-20	2026-01-27	\N	Devuelto	1	1
501	2026-01-20	2026-01-27	\N	Devuelto	1	1
1004	2026-01-20	2026-01-25	\N	Prestado	1	1
\.


--
-- TOC entry 7374 (class 0 OID 23149)
-- Dependencies: 259
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 7586 (class 0 OID 38522641)
-- Dependencies: 341
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

COPY public.usuario (id_usuario, nombre, apellido, cedula, correo, telefono, tipo_usuario, fecha_registro, estado, password_hash) FROM stdin;
2	Ana	Gómez	0102030406	ana@mail.com	0992222222	Docente	2026-01-20	Activo	\N
3	Luis	Martínez	0102030407	luis@mail.com	0993333333	Externo	2026-01-20	Activo	\N
4	Emilia	Tana	1725930570	emilia@gmail.com	099	Estudiante	2026-01-20	Activo	$2y$10$byBX6e2yktSLFvsJXGIAPezBJ1GL6eZzkoa4Mvn6VlPZ9ZBGaw5cS
1	Juan	Pérez	0102030405	juan@mail.com	0991111111	Estudiante	2026-01-20	Activo	$2y$10$4Ex8zFpAzqgwABV680497eBhNp61RGRjizPGxVFa6pDO8wlVK9kBC
\.


--
-- TOC entry 7607 (class 0 OID 0)
-- Dependencies: 348
-- Name: auditoria_id_auditoria_seq; Type: SEQUENCE SET; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

SELECT pg_catalog.setval('public.auditoria_id_auditoria_seq', 3, true);


--
-- TOC entry 7608 (class 0 OID 0)
-- Dependencies: 338
-- Name: autor_id_autor_seq; Type: SEQUENCE SET; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

SELECT pg_catalog.setval('public.autor_id_autor_seq', 4, true);


--
-- TOC entry 7609 (class 0 OID 0)
-- Dependencies: 336
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 5, true);


--
-- TOC entry 7610 (class 0 OID 0)
-- Dependencies: 342
-- Name: libro_id_libro_seq; Type: SEQUENCE SET; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

SELECT pg_catalog.setval('public.libro_id_libro_seq', 4, true);


--
-- TOC entry 7611 (class 0 OID 0)
-- Dependencies: 345
-- Name: prestamo_id_prestamo_seq; Type: SEQUENCE SET; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

SELECT pg_catalog.setval('public.prestamo_id_prestamo_seq', 1004, true);


--
-- TOC entry 7612 (class 0 OID 0)
-- Dependencies: 340
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 4, true);


--
-- TOC entry 7419 (class 2606 OID 38522745)
-- Name: auditoria auditoria_pkey; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_pkey PRIMARY KEY (id_auditoria);


--
-- TOC entry 7399 (class 2606 OID 38522639)
-- Name: autor autor_pkey; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (id_autor);


--
-- TOC entry 7395 (class 2606 OID 38522632)
-- Name: categoria categoria_nombre_categoria_key; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nombre_categoria_key UNIQUE (nombre_categoria);


--
-- TOC entry 7397 (class 2606 OID 38522630)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 7413 (class 2606 OID 38522678)
-- Name: libro_autor libro_autor_pkey; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.libro_autor
    ADD CONSTRAINT libro_autor_pkey PRIMARY KEY (id_libro, id_autor);


--
-- TOC entry 7409 (class 2606 OID 38522668)
-- Name: libro libro_isbn_key; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.libro
    ADD CONSTRAINT libro_isbn_key UNIQUE (isbn);


--
-- TOC entry 7411 (class 2606 OID 38522666)
-- Name: libro libro_pkey; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.libro
    ADD CONSTRAINT libro_pkey PRIMARY KEY (id_libro);


--
-- TOC entry 7417 (class 2606 OID 38522697)
-- Name: prestamo prestamo_pkey; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.prestamo
    ADD CONSTRAINT prestamo_pkey PRIMARY KEY (id_prestamo);


--
-- TOC entry 7402 (class 2606 OID 38522651)
-- Name: usuario usuario_cedula_key; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_cedula_key UNIQUE (cedula);


--
-- TOC entry 7404 (class 2606 OID 38522653)
-- Name: usuario usuario_correo_key; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_correo_key UNIQUE (correo);


--
-- TOC entry 7406 (class 2606 OID 38522649)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 7407 (class 1259 OID 38522714)
-- Name: idx_libro_titulo; Type: INDEX; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE INDEX idx_libro_titulo ON public.libro USING btree (titulo);


--
-- TOC entry 7414 (class 1259 OID 38522715)
-- Name: idx_prestamo_estado; Type: INDEX; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE INDEX idx_prestamo_estado ON public.prestamo USING btree (estado);


--
-- TOC entry 7415 (class 1259 OID 38522716)
-- Name: idx_prestamo_usuario; Type: INDEX; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE INDEX idx_prestamo_usuario ON public.prestamo USING btree (id_usuario);


--
-- TOC entry 7400 (class 1259 OID 38522713)
-- Name: idx_usuario_cedula; Type: INDEX; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE INDEX idx_usuario_cedula ON public.usuario USING btree (cedula);


--
-- TOC entry 7425 (class 2620 OID 38522801)
-- Name: prestamo trg_auditoria_delete; Type: TRIGGER; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TRIGGER trg_auditoria_delete AFTER DELETE ON public.prestamo FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria();


--
-- TOC entry 7426 (class 2620 OID 38522787)
-- Name: prestamo trg_auditoria_insert; Type: TRIGGER; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TRIGGER trg_auditoria_insert AFTER INSERT ON public.prestamo FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria();


--
-- TOC entry 7427 (class 2620 OID 38522800)
-- Name: prestamo trg_auditoria_update; Type: TRIGGER; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

CREATE TRIGGER trg_auditoria_update AFTER UPDATE ON public.prestamo FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria();


--
-- TOC entry 7420 (class 2606 OID 38522669)
-- Name: libro fk_categoria; Type: FK CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.libro
    ADD CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) REFERENCES public.categoria(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7423 (class 2606 OID 38522703)
-- Name: prestamo fk_libro; Type: FK CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.prestamo
    ADD CONSTRAINT fk_libro FOREIGN KEY (id_libro) REFERENCES public.libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7424 (class 2606 OID 38522698)
-- Name: prestamo fk_usuario; Type: FK CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.prestamo
    ADD CONSTRAINT fk_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 7421 (class 2606 OID 38522684)
-- Name: libro_autor libro_autor_id_autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.libro_autor
    ADD CONSTRAINT libro_autor_id_autor_fkey FOREIGN KEY (id_autor) REFERENCES public.autor(id_autor) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7422 (class 2606 OID 38522679)
-- Name: libro_autor libro_autor_id_libro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: uopjjbtugtnt5ilyi0t3
--

ALTER TABLE ONLY public.libro_autor
    ADD CONSTRAINT libro_autor_id_libro_fkey FOREIGN KEY (id_libro) REFERENCES public.libro(id_libro) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 7600 (class 0 OID 0)
-- Dependencies: 48
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO uopjjbtugtnt5ilyi0t3;


-- Completed on 2026-01-20 19:19:48

--
-- PostgreSQL database dump complete
--

\unrestrict fvzUXRrYY5n3JvvA0KoVS25dpSXyeMctTEfwLbqThpTJz6pRxMb8IlC8bE6DPcE

