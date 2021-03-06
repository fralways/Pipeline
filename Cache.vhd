library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use STD.textio.all;

entity Cache is
port
(
	clk : in std_logic;
	rd_instr : in std_logic;
	rd_data : in std_logic;
	wr : in std_logic;
	address_in : in std_logic_vector(31 downto 0);
	data_in : in std_logic_vector(31 downto 0);
	
	data_out : out std_logic_vector(31 downto 0)

);
end Cache;

architecture CacheArch of Cache is

procedure read_instruction_from_file(instr_num:integer; return_address: out std_logic_vector; return_value: out std_logic_vector; mode: integer) is
	file loaded_file: text;
	variable linija: line;
	variable whitespace: character;
	variable temp_value: std_logic_vector(31 downto 0);
	variable i: integer range 0 to 1000 := 0;
begin
		if (mode = 0) then 
			file_open(loaded_file,"C:\Users\Filip\Desktop\Pipeline\ulazni fajl.txt", READ_MODE);
		else
			file_open(loaded_file,"C:\Users\Filip\Desktop\Pipeline\ulazni data fajl.txt", READ_MODE);
		end if;
		
		readline(loaded_file, linija);
		hread(linija, temp_value);
		if (instr_num = 0 and mode = 0) then
			return_address := temp_value;
			return_value:= temp_value;
		else
			while (i<1000) loop
				i:=i+1;
				if not endfile(loaded_file) then
					readline(loaded_file, linija);
					hread(linija, temp_value);
					if (to_integer(unsigned(temp_value)) = instr_num) then-- nasli smo koja nam treba
						return_address := temp_value;
						read(linija, whitespace); --pojedi razmak
						read(linija, return_value);
						if (mode = 0) then
							exit;
						end if;
						--exit;  --komentarisano jer radi append u write to file, sto znaci da moze imati vise istih adresa, i tad uzima onu poslednju koju nadje
					end if;
				else
					return_address:= (31 downto 0 => '0');
					return_value:= (31 downto 0 => '0');
					exit;
				end if;
			end loop;
		end if;
end read_instruction_from_file;

procedure write_instruction_to_file(instr_address:integer; data_in: in std_logic_vector) is

	file loaded_file: text;
	variable linija: line;
	variable whitespace: character:= ' ';

begin
	
	file_open(loaded_file,"C:\Users\Filip\Desktop\Pipeline\ulazni data fajl.txt", APPEND_MODE);
	
	hwrite(linija, address_in);
	write(linija, whitespace);
	write(linija, data_in);
	writeline(loaded_file, linija);
   writeline(output, linija);

end write_instruction_to_file;

begin

process(clk)
	variable line_for_output : line;
	variable read_address : std_logic_vector(31 downto 0);
	variable read_value : std_logic_vector(31 downto 0);
	variable instr_address : integer;

begin
	if (rising_edge(clk)) then
		if (rd_instr = '1') then
			instr_address := to_integer(unsigned(address_in));
			read_instruction_from_file(instr_address, read_address, read_value, 0);
		
			write(line_for_output, read_value);
			writeline(output, line_for_output);
			
			data_out <= read_value;
		elsif (rd_data = '1') then
			instr_address := to_integer(unsigned(address_in));
			read_instruction_from_file(instr_address, read_address, read_value, 1);
		
			write(line_for_output, read_address);
			writeline(output, line_for_output);
			
			data_out <= read_value;
		elsif (wr = '1') then
			instr_address := to_integer(unsigned(address_in));
			write_instruction_to_file(instr_address, data_in);
		end if;
			
	end if;
		
end process;

end CacheArch;
