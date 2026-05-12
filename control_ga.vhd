library ieee;
	use ieee.std_logic_1164.all;
	--use ieee.numeric_std.all;

entity control_ga is

	generic ( Npob : natural := 6;  -- Cantidad de individuos por generacion --"Originalmente es de 40 individuos la poblacion"--
				 Ngen : natural := 2; -- Cantidad de generaciones              --"Usamos 60 generaciones segun simulaciones en python"--
				Nbins : natural := 5);
	port(
		clk		 : in	 std_logic;
		prng_mut	 : in  std_logic;   -- Bit de entrada proveniente de un LFSR que indica si ese individuo muta o no (si prng_mut = '0' NO muta)
		rst	    : in	 std_logic;
		O_gi,O_eval,O_guardar,O_elit,O_cross,O_mut : out std_logic
	);

end entity;

architecture uno of control_ga is

	type state_type is (GI, EVAL, GUARDAR, ELIT, CROSS, MUT);
	signal state  : state_type;
	
	signal count  : integer range 0 to Npob;
	signal count2 : integer range 0 to Npob*Ngen;
	signal countNbins : integer range 0 to Nbins;

begin

	process (clk, rst)
	begin
		if rst = '0' then
			count <= 0;
			countNbins <= 0;
			state <= GI;
		elsif (rising_edge(clk)) then
			case state is
			--------------------------------------
			--------------------------------------
				when GI=>
					if countNbins < Nbins then
						state <= GI;
						countNbins <= countNbins + 1;
					else
						count <= count + 1;
						state <= EVAL;
					end if;
			--------------------------------------
			--------------------------------------
				when EVAL=>
					state <= GUARDAR;
			--------------------------------------
			--------------------------------------
				when GUARDAR=>
					if count = Npob then
						state <= ELIT;
					else
						state <= GI;
					end if;
			--------------------------------------
			--------------------------------------
				when ELIT =>
					count2 <= count2 + 1;
					if count2 = Npob*Ngen then
						state  <= GI;
						count  <= 0;
						count2 <= 0;
					else
						count2 <= count2 + 1;
						state <= CROSS;
					end if;
			--------------------------------------
			--------------------------------------
				when CROSS =>
					if prng_mut = '0' then
						state <= EVAL;
					else
						state <= MUT;
					end if;
			--------------------------------------
			--------------------------------------
				when MUT =>
					state <= EVAL;
			--------------------------------------
			--------------------------------------
			end case;
		end if;
	end process;

	process (state)
	begin
		case state is
			when GI =>
				O_gi      <= '1';
				O_eval    <= '0';
				O_guardar <= '0';
				O_elit    <= '0';
				O_cross   <= '0';
				O_mut     <= '0';
			when EVAL =>
				O_gi      <= '0';
				O_eval    <= '1';
				O_guardar <= '0';
				O_elit    <= '0';
				O_cross   <= '0';
				O_mut     <= '0';
			when GUARDAR =>
				O_gi      <= '0';
				O_eval    <= '0';
				O_guardar <= '1';
				O_elit    <= '0';
				O_cross   <= '0';
				O_mut     <= '0';
			when ELIT =>
				O_gi      <= '0';
				O_eval    <= '0';
				O_guardar <= '0';
				O_elit    <= '1';
				O_cross   <= '0';
				O_mut     <= '0';
			when CROSS =>
				O_gi      <= '0';
				O_eval    <= '0';
				O_guardar <= '0';
				O_elit    <= '0';
				O_cross   <= '1';
				O_mut     <= '0';
			when MUT =>
				O_gi      <= '0';
				O_eval    <= '0';
				O_guardar <= '0';
				O_elit    <= '0';
				O_cross   <= '0';
				O_mut     <= '1';
		end case;
	end process;

end uno;
