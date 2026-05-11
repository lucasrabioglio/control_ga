library ieee;
	use ieee.std_logic_1164.all;
	--use ieee.numeric_std.all;

entity control_ga is

	generic ( Npob : natural := 40;  -- Cantidad de individuos por generacion
				 Ngen : natural := 60); -- Cantidad de generaciones
	port(
		clk		 : in	 std_logic;
		prng_mut	 : in  std_logic;   -- Bit de entrada proveniente de un LFSR que indica si ese individuo muta o no (si prng_mut = '0' NO muta)
		rst	    : in	 std_logic;
		sel	    : out std_logic_vector(2 downto 0)
	);

end entity;

architecture uno of control_ga is

	type state_type is (GI, EVAL, GUARDAR, ELIT, CROSS, MUT);
	signal state  : state_type;
	
	signal count  : integer range 0 to Npob;
	signal count2 : integer range 0 to Npob*Ngen;

begin

	process (clk, rst)
	begin
		if rst = '0' then
			count <= 0;
			state <= GI;
		elsif (rising_edge(clk)) then
			case state is
			
				when GI=>
					count <= count + 1;
					state <= EVAL;
					
				when EVAL=>
					state <= GUARDAR;
					
				when GUARDAR=>
					if count = Npob then
						state <= ELIT;
					else
						state <= GI;
					end if;
					
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
					
				when CROSS =>
					if prng_mut = '0' then
						state <= EVAL;
					else
						state <= MUT;
					end if;
					
				when MUT =>
					state <= EVAL;
					
			end case;
		end if;
	end process;

	process (state)
	begin
		case state is
			when GI =>
				sel <= "000";
			when EVAL =>
				sel <= "001";
			when GUARDAR =>
				sel <= "010";
			when ELIT =>
				sel <= "011";
			when CROSS =>
				sel <= "100";
			when MUT =>
				sel <= "101";
		end case;
	end process;

end uno;
