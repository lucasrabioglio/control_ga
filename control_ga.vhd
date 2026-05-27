library ieee;
	use ieee.std_logic_1164.all;
	--use ieee.numeric_std.all;

entity control_ga is

	generic ( Npob : natural := 40;  -- Cantidad de individuos por generacion --"Originalmente es de 40 individuos la poblacion"--
				 Ngen : natural := 100; -- Cantidad de generaciones              --"Usamos 60 generaciones segun simulaciones en python"--
				Nbins : natural := 512);
	port(
		clk,rst	: in	std_logic;
		fin_hist : in  std_logic;
		fin_eval : in  std_logic;
		Hpob_i,sel,Helite,Hguar,Hcros,Hpmut,Hmejor : out std_logic
	);

end entity;

architecture uno of control_ga is

	type state_type is (INICIO,CONTEO,EVAL,ELITE,PADRE,CRUCE,MUT,FIN);
	signal state  : state_type;
	
	---------- CONTADOR DE POBLACION INICIAL ----------
	signal Cpob_i,Cpob : integer range 0 to (Npob - 1);
	
	---------- CONTADOR DE GENERACIONES ----------
	signal Cgen : integer range 0 to (Ngen);
	
begin

	process (clk, rst)
	begin
		if rst = '0' then
			state <= INICIO;
		elsif (rising_edge(clk)) then
			case state is
			--------------------------------------
			--------------------------------------
				when INICIO=>
					if fin_hist = '0' then
						state <= INICIO;
					else
						state <= CONTEO;
					end if;
					
			--------------------------------------
			--------------------------------------
				when CONTEO=>
					Cpob_i <= Cpob_i + 1;
					state <= EVAL;
					
			--------------------------------------
			--------------------------------------
				when EVAL=>
					if fin_eval = '0' then
						state <= EVAL;
					else
						state <= ELITE;
						Cpob <= Cpob + 1;
					end if;
					
			--------------------------------------
			--------------------------------------
				when ELITE =>
					if (Cpob_i = Npob - 1) then
						if (Cpob = Npob - 1) then
							state <= PADRE;
						else
							state <= CRUCE;
						end if;
					else
						state <= INICIO;
					end if;
					
			--------------------------------------
			--------------------------------------
				when PADRE =>
					Cgen <= Cgen + 1;
					Cpob <= 0;
					state <= CRUCE;
			--------------------------------------
			--------------------------------------
				when CRUCE =>
					if (Cgen = Ngen) then
						state <= FIN;
					else
						state <= EVAL;
					end if;
					state <= MUT;
					
			--------------------------------------
			--------------------------------------
				when MUT	=>
					if (Cgen = Ngen) then
						state <= FIN;
					else
						state <= EVAL;
					end if;
					
			--------------------------------------
			--------------------------------------
				when FIN =>
					Cpob_i <= 0;
					Cgen   <= 0;
			--------------------------------------
			--------------------------------------
			end case;
		end if;
	end process;
	
	process (state)
	begin
		case state is
			when INICIO =>
				Hpob_i <= '1';
				sel    <= '0';
				Helite <= '0';
				Hguar  <= '0';
				Hcros  <= '0';
				Hpmut  <= '0';
				Hmejor <= '0';
			when CONTEO =>
				Hpob_i <= '0';
				sel    <= '0';
				Helite <= '0';
				Hguar  <= '0';
				Hcros  <= '0';
				Hpmut  <= '0';
				Hmejor <= '0';
			when EVAL =>
				Hpob_i <= '0';
				sel    <= '0';
				Helite <= '0';
				Hguar  <= '0';
				Hcros  <= '0';
				Hpmut  <= '0';
				Hmejor <= '0';
			when ELITE =>
				Hpob_i <= '0';
				sel    <= '0';
				Helite <= '1';
				Hguar  <= '0';
				Hcros  <= '0';
				Hpmut  <= '0';
				Hmejor <= '0';
			when PADRE =>
				Hpob_i <= '0';
				sel    <= '0';
				Helite <= '0';
				Hguar  <= '1';
				Hcros  <= '0';
				Hpmut  <= '0';
				Hmejor <= '0';
			when CRUCE =>
				Hpob_i <= '0';
				sel    <= '1';
				Helite <= '0';
				Hguar  <= '0';
				Hcros  <= '1';
				Hpmut  <= '0';
				Hmejor <= '0';
			when MUT =>
				Hpob_i <= '0';
				sel    <= '0';
				Helite <= '0';
				Hguar  <= '0';
				Hcros  <= '0';
				Hpmut  <= '1';
				Hmejor <= '0';
			when FIN =>
				Hpob_i <= '0';
				sel    <= '0';
				Helite <= '0';
				Hguar  <= '0';
				Hcros  <= '0';
				Hpmut  <= '0';
				Hmejor <= '1';
		end case;
	end process;

end uno;
