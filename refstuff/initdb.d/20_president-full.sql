\c presidents exam
begin work;

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2 (Ubuntu 13.2-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.2 (Ubuntu 13.2-1.pgdg20.04+1)
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_vpres; Type: TABLE; Schema: public; Owner: exam
--

CREATE TABLE public.admin_vpres (
    admin_id integer NOT NULL,
    vice_pres_name character varying(20) NOT NULL
);


ALTER TABLE public.admin_vpres OWNER TO exam;

--
-- Name: TABLE admin_vpres; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON TABLE public.admin_vpres IS 'President and vice president';


--
-- Name: administration; Type: TABLE; Schema: public; Owner: exam
--

CREATE TABLE public.administration (
    id integer NOT NULL,
    admin_nr integer NOT NULL,
    pres_id integer NOT NULL,
    year_inaugurated integer,
    CONSTRAINT check_year_inaug CHECK (((year_inaugurated >= 1600) AND (year_inaugurated <= 2100)))
);


ALTER TABLE public.administration OWNER TO exam;

--
-- Name: TABLE administration; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON TABLE public.administration IS 'Name of president, administration number and year of inauguration';


--
-- Name: administration_id_seq; Type: SEQUENCE; Schema: public; Owner: exam
--

CREATE SEQUENCE public.administration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.administration_id_seq OWNER TO exam;

--
-- Name: administration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: exam
--

ALTER SEQUENCE public.administration_id_seq OWNED BY public.administration.id;


--
-- Name: election; Type: TABLE; Schema: public; Owner: exam
--

CREATE TABLE public.election (
    election_year integer NOT NULL,
    candidate character varying(20) NOT NULL,
    votes integer,
    winner_loser_indic character(1),
    CONSTRAINT check_election_year CHECK (((election_year >= 1600) AND (election_year <= 2100))),
    CONSTRAINT check_votes CHECK ((votes > 0)),
    CONSTRAINT check_winner_loser_indic CHECK (((winner_loser_indic = 'W'::bpchar) OR (winner_loser_indic = 'L'::bpchar)))
);


ALTER TABLE public.election OWNER TO exam;

--
-- Name: TABLE election; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON TABLE public.election IS 'Election year, vote count (electoral vote, by delegate), won or lost';


--
-- Name: pres_hobby; Type: TABLE; Schema: public; Owner: exam
--

CREATE TABLE public.pres_hobby (
    pres_id integer NOT NULL,
    hobby character varying(20) NOT NULL
);


ALTER TABLE public.pres_hobby OWNER TO exam;

--
-- Name: TABLE pres_hobby; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON TABLE public.pres_hobby IS 'Hobby of the president';


--
-- Name: pres_marriage; Type: TABLE; Schema: public; Owner: exam
--

CREATE TABLE public.pres_marriage (
    pres_id integer NOT NULL,
    spouse_name character varying(20) NOT NULL,
    spouse_age smallint,
    nr_children smallint,
    marriage_year integer,
    CONSTRAINT check_marriage_year CHECK (((marriage_year >= 1600) AND (marriage_year <= 2100))),
    CONSTRAINT check_spouse_age CHECK ((spouse_age > 15))
);


ALTER TABLE public.pres_marriage OWNER TO exam;

--
-- Name: TABLE pres_marriage; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON TABLE public.pres_marriage IS 'Marriage, spouce name, year of marriage, age of man and wife, nr of children.';


--
-- Name: president; Type: TABLE; Schema: public; Owner: exam
--

CREATE TABLE public.president (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    birth_year integer,
    years_served smallint,
    death_age smallint,
    party character varying(10),
    state_id_born integer,
    CONSTRAINT check_birth_year CHECK (((birth_year >= 1600) AND (birth_year <= 2100))),
    CONSTRAINT check_death_age CHECK (((death_age > 20) OR (death_age IS NULL)))
);


ALTER TABLE public.president OWNER TO exam;

--
-- Name: TABLE president; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON TABLE public.president IS 'President name, birth year etc.';


--
-- Name: president_id_seq; Type: SEQUENCE; Schema: public; Owner: exam
--

CREATE SEQUENCE public.president_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.president_id_seq OWNER TO exam;

--
-- Name: president_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: exam
--

ALTER SEQUENCE public.president_id_seq OWNED BY public.president.id;


--
-- Name: state; Type: TABLE; Schema: public; Owner: exam
--

CREATE TABLE public.state (
    id integer NOT NULL,
    name character varying(15) NOT NULL,
    admin_id integer,
    year_entered integer,
    CONSTRAINT check_year_entered CHECK (((year_entered >= 1600) AND (year_entered <= 2100)))
);


ALTER TABLE public.state OWNER TO exam;

--
-- Name: TABLE state; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON TABLE public.state IS 'States, added in year and under which president.';


--
-- Name: recent_presidents; Type: VIEW; Schema: public; Owner: exam
--

CREATE VIEW public.recent_presidents AS
 SELECT p.id,
    p.name,
    p.birth_year,
    p.years_served,
    p.death_age,
    p.party,
    s.name AS state_name
   FROM (public.president p
     JOIN public.state s ON ((p.state_id_born = s.id)))
  WHERE (p.birth_year > 1880);


ALTER TABLE public.recent_presidents OWNER TO exam;

--
-- Name: VIEW recent_presidents; Type: COMMENT; Schema: public; Owner: exam
--

COMMENT ON VIEW public.recent_presidents IS 'Presidents born since 1880.';


--
-- Name: state_id_seq; Type: SEQUENCE; Schema: public; Owner: exam
--

CREATE SEQUENCE public.state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.state_id_seq OWNER TO exam;

--
-- Name: state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: exam
--

ALTER SEQUENCE public.state_id_seq OWNED BY public.state.id;


--
-- Name: administration id; Type: DEFAULT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.administration ALTER COLUMN id SET DEFAULT nextval('public.administration_id_seq'::regclass);


--
-- Name: president id; Type: DEFAULT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.president ALTER COLUMN id SET DEFAULT nextval('public.president_id_seq'::regclass);


--
-- Name: state id; Type: DEFAULT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.state ALTER COLUMN id SET DEFAULT nextval('public.state_id_seq'::regclass);


--
-- Data for Name: admin_vpres; Type: TABLE DATA; Schema: public; Owner: exam
--

COPY public.admin_vpres (admin_id, vice_pres_name) FROM stdin;
1	ADAMS J
2	ADAMS J
3	JEFFERSON T
4	BURR A
5	CLINTON G
6	CLINTON G
7	GERRRY E
8	TOMPKINS D
9	TOMPKINS D
10	CALHOUN J
11	CALHOUN J
12	VAN BUREN M
13	JOHNSON R M
14	TYLER J
16	DALLAS J M
17	FILLMORE M
19	DE VANE KING W R
20	BRECKINRIDGE J C
21	HAMLIN H
22	JOHNSON A
24	COLFAX S
25	WILSON H
26	WHEELER W
27	ARTHUR C A
29	HENDRICKS T A
30	MORTON L P
31	STEVENSON A E
32	HOBART G A
33	ROOSEVELT T
35	FAIRBANKS C W
36	SHERMAN J S
37	MARSHALL T R
38	MARSHALL T R
39	COOLIDGE C
41	DAWES C G
42	CURTIS C
43	GARNER J N
44	GARNER J N
45	WALLACE H A
46	TRUMAN H S
48	BARKLEY A W
49	NIXON R M
50	NIXON R M
51	JOHNSON L B
53	HUMPHREY H H
54	AGNEW S T
55	AGNEW S T
55	FORD G R
56	ROCKEFELLER N A
57	MONDALE W F
58	BUSH G H W
59	BUSH G H W
60	QUAYLE D
61	GORE A
62	GORE A
63	CHENEY D
64	CHENEY D
65	BIDEN J
66	BIDEN J
67	PENCE M R
68	HARRIS K D
\.


--
-- Data for Name: administration; Type: TABLE DATA; Schema: public; Owner: exam
--

COPY public.administration (id, admin_nr, pres_id, year_inaugurated) FROM stdin;
0	0	1	1789
1	1	1	1789
2	2	1	1793
3	3	2	1797
4	4	3	1801
5	5	3	1805
6	6	4	1809
7	7	4	1813
8	8	5	1817
9	9	5	1821
10	10	6	1825
11	11	7	1829
12	12	7	1833
13	13	8	1837
14	14	9	1841
15	14	10	1841
16	15	11	1845
17	16	12	1849
18	16	13	1850
19	17	14	1853
20	18	15	1857
21	19	16	1861
22	20	16	1865
23	20	17	1865
24	21	18	1869
25	22	18	1873
26	23	19	1877
27	24	20	1881
28	24	21	1881
29	25	22	1885
30	26	23	1889
31	27	22	1893
32	28	24	1897
33	29	24	1901
34	29	25	1901
35	30	25	1905
36	31	26	1909
37	32	27	1913
38	33	27	1917
39	34	28	1921
40	34	29	1923
41	35	29	1925
42	36	30	1929
43	37	31	1933
44	38	31	1937
45	39	31	1941
46	40	31	1945
47	40	32	1945
48	41	32	1949
49	42	33	1953
50	43	33	1957
51	44	34	1961
52	44	35	1963
53	45	35	1965
54	46	36	1969
55	47	36	1973
56	47	37	1974
57	48	38	1977
58	49	40	1981
59	50	40	1985
60	51	39	1989
61	52	41	1993
62	53	41	1997
63	54	42	2001
64	55	42	2005
65	56	43	2009
66	57	43	2013
67	58	44	2017
68	59	45	2021
\.


--
-- Data for Name: election; Type: TABLE DATA; Schema: public; Owner: exam
--

COPY public.election (election_year, candidate, votes, winner_loser_indic) FROM stdin;
1789	WASHINGTON G	69	W
1789	ADAMS J	34	L
1789	JAY J	9	L
1789	HARRISON R H	6	L
1789	RUTLEDGE J	6	L
1789	HANCOCK J	4	L
1789	CLINTON G	3	L
1789	HUNTINGTON S	2	L
1789	MILTON J	2	L
1789	ARMSTRONG	1	L
1789	LINCOLN B	1	L
1789	TOLFAIR I	1	L
1792	ADAMS J	77	L
1792	CLINTON G	50	L
1792	JEFFERSON T	4	L
1796	PINCKNEY T	59	L
1792	BURR A	1	L
1796	ADAMS J	71	W
1796	JEFFERSON T	68	L
1796	BURR A	30	L
1796	CLINTON G	7	L
1796	JAY J	5	L
1796	IREDELL J	3	L
1796	HENRY J	2	L
1796	JOHNSON S	2	L
1796	WASHINGTON G	2	L
1796	PINCKNEY C C	1	L
1792	WASHINGTON G	132	W
1796	ADAMS S	15	L
1796	ELLSWORTH O	11	L
1800	JEFFERSON T	73	W
1800	BURR A	73	L
1800	ADAMS J	65	L
1800	JAY J	1	L
1804	JEFFERSON T	162	W
1804	PINCKNEY C C	14	L
1800	PINCKNEY C C	64	L
1808	MADISON J	122	W
1808	PINCKNEY C C	47	L
1808	CLINTON G	6	L
1812	MADISON J	128	W
1812	CLINTON G	89	L
1816	MONROE J	183	W
1816	KING R	34	L
1820	MONROE J	231	W
1820	ADAMS J Q	1	L
1824	ADAMS J Q	99	W
1824	JACKSON A	84	L
1824	CRAWFORD W H	41	L
1824	CLAY H	37	L
1828	JACKSON A	178	W
1828	ADAMS J	83	L
1832	JACKSON A	219	W
1832	CLAY H	49	L
1832	FLOYD J	11	L
1832	WIRT W	7	L
1836	VAN BUREN M	170	W
1836	HARRISON W H	73	L
1836	WHITE H L	26	L
1836	WEBSTER D	14	L
1836	MANGUM W P	11	L
1840	HARRISON W H	234	W
1840	VAN BUREN M	60	L
1844	POLK J K	170	W
1844	CLAY H	105	L
1848	TAYLOR Z	163	W
1848	CASS L	126	L
1852	PIERCE F	254	W
1852	SCOTT W	42	L
1856	BUCHANAN J	174	W
1856	FREMONT J C	114	L
1856	FILLMORE M	8	L
1860	LINCOLN A	180	W
1860	BRECKINRIDGE J C	72	L
1860	BELL J	39	L
1860	DOUGLAS S	12	L
1864	LINCOLN A	212	W
1864	MCCLELLAN G B	21	L
1868	GRANT U S	214	W
1868	SEYMOUR H	80	L
1872	GRANT U S	286	W
1872	HENDRICKS T A	42	L
1872	BROWN B G	18	L
1872	JENKINS C J	2	L
1872	DAVIS D	1	L
1876	HAYES R B	185	W
1876	TILDEN R B	184	L
1880	GARFIELD J A	214	W
1880	HANCOCK W S	155	L
1884	CLEVELAND G	219	W
1884	BLAINE J G	182	L
1888	HARRISON B	233	W
1888	CLEVELAND G	168	L
1892	CLEVELAND G	277	W
1892	HARRISON B	145	L
1892	WEAVER J B	22	L
1896	MCKINLEY W	271	W
1896	BRYAN W J	176	L
1900	MCKINLEY W	292	W
1900	BRYAN W J	155	L
1904	ROOSEVELT T	336	W
1904	PARKER E B	140	L
1908	TAFT W H	321	W
1908	BRYAN W J	162	L
1912	WILSON W	435	W
1912	ROOSEVELT T	88	L
1912	TAFT W H	8	L
1916	WILSON W	277	W
1916	HUGHES C E	254	L
1920	HARDING W G	404	W
1920	COX W W	127	L
1924	COOLIDGE C	382	W
1924	DAVIS J W	136	L
1924	LA FOLLETTE R M	13	L
1928	HOOVER H C	444	W
1928	SMITH A E	87	L
1932	ROOSEVELT F D	472	W
1932	HOOVER H C	49	L
1936	ROOSEVELT F D	523	W
1936	LANDON A M	8	L
1940	ROOSEVELT F D	449	W
1940	WILKIE W L	82	L
1944	ROOSEVELT F D	432	W
1944	DEWEY T E	99	L
1948	TRUMAN H S	303	W
1948	DEWEY T E	189	L
1948	THURMOND J S	39	L
1952	EISENHOWER D D	442	W
1952	STEVENSON A E	89	L
1956	EISENHOWER D D	457	W
1956	STEVENSON A E	73	L
1956	JONES W B	1	L
1960	KENNEDY J F	303	W
1960	NIXON R M	219	L
1960	BYRD	15	L
1964	JOHNSON L B	486	W
1964	GOLDWATER B	52	L
1968	NIXON R M	301	W
1968	HUMPHREY H H	191	L
1968	WALLACE G C	46	L
1972	NIXON R M	520	W
1972	MCGOVERN G S	17	L
1972	HOSPERS J	1	L
1976	CARTER J M	297	W
1976	FORD G R	240	L
1980	CARTER J M	49	L
1980	REAGAN R	489	W
1988	BUSH G H W	426	W
1988	DUKAKIS M	111	L
1992	CLINTON W J	370	W
1992	BUSH G H W	168	L
1996	CLINTON W J	379	W
1996	DOLE B	159	L
2000	BUSH G W	271	W
2000	GORE A	266	L
2004	BUSH G W	286	W
2004	KERRY J	251	L
2008	OBAMA B	365	W
2008	MCCAIN J	173	L
2012	OBAMA B	332	W
2012	ROMNEY M	206	L
2016	TRUMP D J	304	W
2016	CLINTON H D R	227	L
2020	BIDEN J R	271	W
2020	TRUMP D J	267	L
\.


--
-- Data for Name: pres_hobby; Type: TABLE DATA; Schema: public; Owner: exam
--

COPY public.pres_hobby (pres_id, hobby) FROM stdin;
6	BILLIARDS
6	SWIMMING
21	FISHING
22	FISHING
29	FISHING
29	GOLF
29	INDIAN CLUBS
29	MECH. HORS
29	PITCHING HAY
33	BRIDGE
33	GOLF
33	HUNTING
33	PAINTING
33	FISHING
20	BILLIARDS
28	GOLF
28	POKER
28	RIDING
23	HUNTING
19	CROQUET
19	DRIVING
19	SHOOTING
30	FISHING
30	MEDICINE BALL
7	RIDING
3	FISHING
3	RIDING
35	RIDING
34	SAILING
34	SWIMMING
34	TOUCH FOOTBALL
16	WALKING
24	RIDING
24	SWIMMING
24	WALKING
36	GOLF
31	FISHING
31	SAILING
31	SWIMMING
25	BOXING
25	HUNTING
25	JUJITSU
25	RIDING
25	SHOOTING
25	TENNIS
25	WRESTLING
26	GOLF
26	RIDING
12	RIDING
32	FISHING
32	POKER
32	WALKING
8	RIDING
1	FISHING
1	RIDING
27	GOLF
27	RIDING
27	WALKING
6	WALKING
40	GOLF
43	COIKING
43	BASKETBALL
43	DANCING
41	PLAYING SAXOPHONE
42	FISHING
42	JOGGING
39	FISHING
44	GOLF
45	CARD AND BOARD GAMES
\.


--
-- Data for Name: pres_marriage; Type: TABLE DATA; Schema: public; Owner: exam
--

COPY public.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) FROM stdin;
1	CUSTIS M D	27	0	1759
2	SMITH A	19	5	1764
3	SKELTON M W	23	6	1772
4	TODD D D P	26	0	1794
5	KORTRIGHT E	17	3	1786
6	JOHNSON L C	22	4	1797
7	ROBARDS R D	26	0	1794
8	HOOS H	23	4	1807
9	SYMMES A T	20	10	1795
10	CHRISTIAN L	22	8	1813
10	GARDINER J	24	7	1844
11	CHILDRESS S	20	0	1824
12	SMITH M M	21	6	1810
13	POWERS A	27	2	1826
13	MCINTOSH C C	44	0	1858
14	APPLETON J M	28	3	1834
16	TODD M	23	4	1842
17	MCCARDLE E	16	5	1827
18	DENT J B	22	4	1848
19	WEBB L W	21	8	1852
20	RUDOLPH L	26	7	1858
21	HERNDON E L	22	3	1859
22	FOLSON F	21	5	1886
23	SCOTT C L	31	2	1853
23	DIMMICK M S L	37	1	1896
24	SAXTON I	23	2	1871
25	LEE A H	19	1	1880
25	CARROW E K	25	5	1886
26	HERRON H	25	3	1886
27	AXSON E L	25	3	1885
27	GALT E B	43	0	1915
28	DE WOLFE F K	30	0	1891
29	GOODHUE G A	26	2	1905
30	HENRY L	23	2	1899
31	ROOSEVELT A E	20	6	1905
32	WALLACE E V	34	1	1919
33	DOUD G	19	2	1916
34	BOUVIER J L	24	3	1953
35	TAYLOR C A	21	2	1934
36	RYAN T C	28	2	1940
37	WARREN E B	30	4	1948
38	SMITH R	18	4	1946
40	WYMAN J	25	2	1940
40	DAVIS N	28	2	1952
39	PIERCE B	20	6	1945
42	WELCH L L	31	2	1977
43	ROBINSON M	28	2	1992
41	RODHAM H	28	1	1975
44	ZELNICKOVA I	28	3	1977
44	MAPLES M	30	1	1993
44	KNAUSS M	34	1	2005
45	HUNTER N	24	3	1966
45	JACOBS J	26	1	1977
\.


--
-- Data for Name: president; Type: TABLE DATA; Schema: public; Owner: exam
--

COPY public.president (id, name, birth_year, years_served, death_age, party, state_id_born) FROM stdin;
1	WASHINGTON G	1732	7	67	FEDERALIST	35
2	ADAMS J	1735	4	90	FEDERALIST	38
3	JEFFERSON T	1743	8	83	DEMO-REP	35
4	MADISON J	1751	8	85	DEMO-REP	35
5	MONROE J	1758	8	73	DEMO-REP	35
6	ADAMS J Q	1767	4	80	DEMO-REP	38
7	JACKSON A	1767	8	78	DEMOCRATIC	40
8	VAN BUREN M	1782	4	79	DEMOCRATIC	46
9	HARRISON W H	1773	0	68	WHIG	35
10	TYLER J	1790	3	71	WHIG	35
11	POLK J K	1795	4	53	DEMOCRATIC	47
12	TAYLOR Z	1784	1	65	WHIG	35
13	FILLMORE M	1800	2	74	WHIG	46
14	PIERCE F	1804	4	64	DEMOCRATIC	44
15	BUCHANAN J	1791	4	77	DEMOCRATIC	37
16	LINCOLN A	1809	4	56	REPUBLICAN	49
17	JOHNSON A	1808	3	66	DEMOCRATIC	37
18	GRANT U S	1822	8	63	REPUBLICAN	1
19	HAYES R B	1822	4	70	REPUBLICAN	1
20	GARFIELD J A	1831	0	49	REPUBLICAN	1
21	ARTHUR C A	1830	3	56	REPUBLICAN	36
22	CLEVELAND G	1837	8	71	DEMOCRATIC	42
23	HARRISON B	1833	4	67	REPUBLICAN	1
24	MCKINLEY W	1843	4	58	REPUBLICAN	1
25	ROOSEVELT T	1858	7	60	REPUBLICAN	46
26	TAFT W H	1857	4	72	REPUBLICAN	1
27	WILSON W	1856	8	67	DEMOCRATIC	35
28	HARDING W G	1865	2	57	REPUBLICAN	1
29	COOLIDGE C	1872	5	60	REPUBLICAN	36
30	HOOVER H C	1874	4	90	REPUBLICAN	13
31	ROOSEVELT F D	1882	12	63	DEMOCRATIC	46
32	TRUMAN H S	1884	7	88	DEMOCRATIC	8
33	EISENHOWER D D	1890	8	79	REPUBLICAN	12
34	KENNEDY J F	1917	2	46	DEMOCRATIC	38
35	JOHNSON L B	1908	5	65	DEMOCRATIC	12
36	NIXON R M	1913	5	81	REPUBLICAN	15
37	FORD G R	1913	2	93	REPUBLICAN	21
38	CARTER J M	1924	4	\N	DEMOCRATIC	43
39	BUSH G H W	1924	4	\N	REPUBLICAN	38
40	REAGAN R	1911	8	93	REPUBLICAN	5
41	CLINTON W J	1946	8	\N	DEMOCRATIC	9
42	BUSH G W	1946	8	\N	REPUBLICAN	39
43	OBAMA B	1961	8	\N	DEMOCRATIC	34
44	TRUMP D J	1946	4	\N	REPUBLICAN	46
45	BIDEN J R	1942	0	\N	DEMOCRATIC	37
\.


--
-- Data for Name: state; Type: TABLE DATA; Schema: public; Owner: exam
--

COPY public.state (id, name, admin_id, year_entered) FROM stdin;
1	OHIO	4	1803
2	LOUISIANNA	6	1812
3	INDIANA	7	1816
4	MISSISSIPI	8	1817
5	ILLINOIS	8	1818
6	ALABAMA	8	1819
7	MAINE	8	1820
8	MISSOURI	9	1821
9	ARKANSAS	12	1836
10	MICHIGAN	12	1837
11	FLORIDA	15	1845
12	TEXAS	16	1845
13	IOWA	16	1846
14	WISCONSIN	16	1848
15	CALIFORNIA	18	1850
16	MINNESOTA	20	1858
17	OREGON	20	1859
18	KANSAS	20	1861
19	WEST VIRGINIA	21	1863
20	NEVADA	21	1864
21	NEBRASKA	22	1867
22	COLORADO	25	1876
23	NORTH DAKOTA	30	1889
24	SOUTH DAKOTA	30	1889
25	MONTANA	30	1889
26	WASHINGTON	30	1889
27	IDAHO	30	1890
28	WYOMING	30	1890
29	UTAH	31	1896
30	OKLAHOMA	35	1907
31	NEW MEXICO	36	1912
32	ARIZONA	36	1912
33	ALASKA	50	1959
34	HAWAII	50	1959
35	VIRGINIA	0	1776
36	VERMONT	1	1791
37	PENNSYLVANIA	0	1776
38	MASSACHUSETTS	0	1776
39	CONNECTICUT	0	1776
40	SOUTH CAROLINA	0	1776
41	MARYLAND	0	1776
42	NEW JERSEY	0	1776
43	GEORGIA	0	1776
44	NEW HAMPSHIRE	0	1776
45	DELAWARE	0	1776
46	NEW YORK	0	1776
47	NORTH CAROLINA	0	1776
48	RHODE ISLAND	0	1776
49	KENTUCKY	1	1792
50	TENNESSEE	2	1796
\.


--
-- Name: administration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: exam
--

SELECT pg_catalog.setval('public.administration_id_seq', 67, true);


--
-- Name: president_id_seq; Type: SEQUENCE SET; Schema: public; Owner: exam
--

SELECT pg_catalog.setval('public.president_id_seq', 44, true);


--
-- Name: state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: exam
--

SELECT pg_catalog.setval('public.state_id_seq', 50, true);


--
-- Name: administration prim_key_adm; Type: CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.administration
    ADD CONSTRAINT prim_key_adm PRIMARY KEY (id);


--
-- Name: admin_vpres prim_key_admvp; Type: CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.admin_vpres
    ADD CONSTRAINT prim_key_admvp PRIMARY KEY (admin_id, vice_pres_name);


--
-- Name: election prim_key_elec; Type: CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.election
    ADD CONSTRAINT prim_key_elec PRIMARY KEY (election_year, candidate);


--
-- Name: pres_hobby prim_key_hobby; Type: CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.pres_hobby
    ADD CONSTRAINT prim_key_hobby PRIMARY KEY (pres_id, hobby);


--
-- Name: president prim_key_pres; Type: CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.president
    ADD CONSTRAINT prim_key_pres PRIMARY KEY (id);


--
-- Name: pres_marriage prim_key_presmar; Type: CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.pres_marriage
    ADD CONSTRAINT prim_key_presmar PRIMARY KEY (pres_id, spouse_name);


--
-- Name: state prim_key_state; Type: CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT prim_key_state PRIMARY KEY (id);


--
-- Name: iadmin; Type: INDEX; Schema: public; Owner: exam
--

CREATE INDEX iadmin ON public.administration USING btree (pres_id, year_inaugurated);


--
-- Name: iadminnrpresid; Type: INDEX; Schema: public; Owner: exam
--

CREATE UNIQUE INDEX iadminnrpresid ON public.administration USING btree (admin_nr, pres_id);


--
-- Name: ipres; Type: INDEX; Schema: public; Owner: exam
--

CREATE INDEX ipres ON public.president USING btree (party);


--
-- Name: admin_vpres admin_vpres_fk1; Type: FK CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.admin_vpres
    ADD CONSTRAINT admin_vpres_fk1 FOREIGN KEY (admin_id) REFERENCES public.administration(id);


--
-- Name: administration administration_fk1; Type: FK CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.administration
    ADD CONSTRAINT administration_fk1 FOREIGN KEY (pres_id) REFERENCES public.president(id);


--
-- Name: pres_hobby pres_hobby_fk1; Type: FK CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.pres_hobby
    ADD CONSTRAINT pres_hobby_fk1 FOREIGN KEY (pres_id) REFERENCES public.president(id);


--
-- Name: pres_marriage pres_marriage_fk1; Type: FK CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.pres_marriage
    ADD CONSTRAINT pres_marriage_fk1 FOREIGN KEY (pres_id) REFERENCES public.president(id);


--
-- Name: president president_fk1; Type: FK CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.president
    ADD CONSTRAINT president_fk1 FOREIGN KEY (state_id_born) REFERENCES public.state(id);


--
-- Name: state state_fk1; Type: FK CONSTRAINT; Schema: public; Owner: exam
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_fk1 FOREIGN KEY (admin_id) REFERENCES public.administration(id);


--
-- PostgreSQL database dump complete
--

commit;