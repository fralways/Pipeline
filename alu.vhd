library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
port
(
	mode : in std_logic_vector(5 downto 0);
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	
	output : out std_logic_vector(31 downto 0)
);
end alu;

architecture alu_arch of alu is

begin
	process (mode, A, B)
		--variable temp_vector : std_logic_vector(31 downto 0);
	begin
		case mode is
			when "000100" => --MOV rs1
				output <= A;
			when "000101" => --MOV immed
				output <= B;
			when "001000" => --add rs1 + rs2
				output <= std_logic_vector(signed(A) + signed(B));
			when "001001" => --sub
				output <= std_logic_vector(signed(A) - signed(B));
			when "001100" => --addi rs1 + immed
				output <= std_logic_vector(signed(A) + signed(B));
			when "001101" => --subi
				output <= std_logic_vector(signed(A) + signed(B));
			when "010000" => --and
				output <= std_logic_vector(signed(A) and signed(B));
			when "010001" => --or
				output <= std_logic_vector(signed(A) or signed(B));
			when "010010" => --xor
				output <= std_logic_vector(signed(A) xor signed(B));
			when "010011" => --not
				output <= std_logic_vector( not (signed(A) and signed(B)) );
			when "011000" => --shl
				output <= std_logic_vector(SHIFT_LEFT(signed(A), to_integer(unsigned(B))));
			when "011001" => --shr
				output <= std_logic_vector(SHIFT_RIGHT(signed(A), to_integer(unsigned(B))));
			when "011010" => --sar
				--temp_vector := (31 => A(31), 30 downto 0 => '0');
				--output <= std_logic_vector(SHIFT_RIGHT(unsigned(A), to_integer(unsigned(B))) or (not(SHIFT_RIGHT(unsigned(temp_vector), to_integer(unsigned(B))))));
				output <= std_logic_vector(SHIFT_RIGHT(signed(A), to_integer(unsigned(B))));	
			when "011011" => --rol
				output <= std_logic_vector(ROTATE_LEFT(signed(A), to_integer(unsigned(B))));
			when "011100" => --ror
				output <= std_logic_vector(ROTATE_RIGHT(signed(A), to_integer(unsigned(B))));
			when "100000" => --JMP RS1 + immed
				output <= std_logic_vector(signed(A) + signed(B));
			when "100001" => --JSR RS1 + immed
				output <= std_logic_vector(signed(A) + signed(B));
				
			-- //////// RTS, PUSH, POP N/A
				
			when "101000" => --BEQ COMPARE RS1 AND RS2 - and make output true/false
				if (unsigned(A) = unsigned(B)) then
					output <= ( 31 downto 1 => '0', 
									0 => '1');
				else
					output <= (others => '0');
				end if;
			when "101001" => --BNQ
				if (unsigned(A) /= unsigned(B)) then
					output <= ( 31 downto 1 => '0', 
									0 => '1');
				else
					output <= (others => '0');
				end if;
			when "101010" => --BGT
				if (unsigned(A) > unsigned(B)) then
					output <= ( 31 downto 1 => '0', 
									0 => '1');
				else
					output <= (others => '0');
				end if;
			when "101011" => --BLT
				if (unsigned(A) < unsigned(B)) then
					output <= ( 31 downto 1 => '0', 
									0 => '1');
				else
					output <= (others => '0');
				end if;
			when "101100" => --BGE
				if (unsigned(A) >= unsigned(B)) then
					output <= ( 31 downto 1 => '0', 
									0 => '1');
				else
					output <= (others => '0');
				end if;
			when "101101" => --BLE
				if (unsigned(A) <= unsigned(B)) then
					output <= ( 31 downto 1 => '0', 
									0 => '1');
				else
					output <= (others => '0');
				end if;
				
			-- ///////// HALT N/A
			
			when others =>
				output <= (others=>'X');
			end case;
	end process;
end alu_arch;