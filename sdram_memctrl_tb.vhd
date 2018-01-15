library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;


entity sdram_memctrl_tb is
end sdram_memctrl_tb;


architecture Behavioral of sdram_memctrl_tb is

-----------------------------
-- Components ---------------
-----------------------------



COMPONENT mt48lc16m16a2 IS
    PORT (
        BA0             : IN    std_logic := 'U';
        BA1             : IN    std_logic := 'U';
        DQMH            : IN    std_logic := 'U';
        DQML            : IN    std_logic := 'U';
        DQ0             : INOUT std_logic := 'U';
        DQ1             : INOUT std_logic := 'U';
        DQ2             : INOUT std_logic := 'U';
        DQ3             : INOUT std_logic := 'U';
        DQ4             : INOUT std_logic := 'U';
        DQ5             : INOUT std_logic := 'U';
        DQ6             : INOUT std_logic := 'U';
        DQ7             : INOUT std_logic := 'U';
        DQ8             : INOUT std_logic := 'U';
        DQ9             : INOUT std_logic := 'U';
        DQ10            : INOUT std_logic := 'U';
        DQ11            : INOUT std_logic := 'U';
        DQ12            : INOUT std_logic := 'U';
        DQ13            : INOUT std_logic := 'U';
        DQ14            : INOUT std_logic := 'U';
        DQ15            : INOUT std_logic := 'U';
        CLK             : IN    std_logic := 'U';
        CKE             : IN    std_logic := 'U';
        A0              : IN    std_logic := 'U';
        A1              : IN    std_logic := 'U';
        A2              : IN    std_logic := 'U';
        A3              : IN    std_logic := 'U';
        A4              : IN    std_logic := 'U';
        A5              : IN    std_logic := 'U';
        A6              : IN    std_logic := 'U';
        A7              : IN    std_logic := 'U';
        A8              : IN    std_logic := 'U';
        A9              : IN    std_logic := 'U';
        A10             : IN    std_logic := 'U';
        A11             : IN    std_logic := 'U';
        A12             : IN    std_logic := 'U';
        WENeg           : IN    std_logic := 'U';
        RASNeg          : IN    std_logic := 'U';
        CSNeg           : IN    std_logic := 'U';
        CASNeg          : IN    std_logic := 'U'
    );
END COMPONENT mt48lc16m16a2;

COMPONENT mt48lc32m16a2 IS
    PORT (
        BA0             : IN    std_logic := 'U';
        BA1             : IN    std_logic := 'U';
        DQMH            : IN    std_logic := 'U';
        DQML            : IN    std_logic := 'U';
        DQ0             : INOUT std_logic := 'U';
        DQ1             : INOUT std_logic := 'U';
        DQ2             : INOUT std_logic := 'U';
        DQ3             : INOUT std_logic := 'U';
        DQ4             : INOUT std_logic := 'U';
        DQ5             : INOUT std_logic := 'U';
        DQ6             : INOUT std_logic := 'U';
        DQ7             : INOUT std_logic := 'U';
        DQ8             : INOUT std_logic := 'U';
        DQ9             : INOUT std_logic := 'U';
        DQ10            : INOUT std_logic := 'U';
        DQ11            : INOUT std_logic := 'U';
        DQ12            : INOUT std_logic := 'U';
        DQ13            : INOUT std_logic := 'U';
        DQ14            : INOUT std_logic := 'U';
        DQ15            : INOUT std_logic := 'U';
        CLK             : IN    std_logic := 'U';
        CKE             : IN    std_logic := 'U';
        A0              : IN    std_logic := 'U';
        A1              : IN    std_logic := 'U';
        A2              : IN    std_logic := 'U';
        A3              : IN    std_logic := 'U';
        A4              : IN    std_logic := 'U';
        A5              : IN    std_logic := 'U';
        A6              : IN    std_logic := 'U';
        A7              : IN    std_logic := 'U';
        A8              : IN    std_logic := 'U';
        A9              : IN    std_logic := 'U';
        A10             : IN    std_logic := 'U';
        A11             : IN    std_logic := 'U';
        A12             : IN    std_logic := 'U';
        WENeg           : IN    std_logic := 'U';
        RASNeg          : IN    std_logic := 'U';
        CSNeg           : IN    std_logic := 'U';
        CASNeg          : IN    std_logic := 'U'
    );
END COMPONENT mt48lc32m16a2;

COMPONENT memctrl IS
PORT( 
  -- clock and reset
  clk       : IN     std_logic;
  rst       : IN     std_logic;
  -- controls
  W_REQ     : IN     std_logic;
  R_REQ     : IN     std_logic;
  RW_ACK    : OUT    std_logic;
  R_VALID   : OUT    std_logic;
  RADDR     : IN     std_logic_vector ( 31 DOWNTO 0 );
  CacheDout : IN     std_logic_vector (  15 DOWNTO 0 );
  SdramDout : OUT    std_logic_vector (  15 DOWNTO 0 );
  -- SDRAM
  MemClk    : OUT    std_logic;
  MemCKE    : OUT    STD_LOGIC;
  MemCS     : OUT    STD_LOGIC;
  MemRAS    : OUT    STD_LOGIC;
  MemCAS    : OUT    STD_LOGIC;
  MemWE     : OUT    std_logic;
  MemBA     : OUT    std_logic_vector (  1 DOWNTO 0 );
  MemAddr   : OUT    std_logic_vector ( 12 DOWNTO 0 );
  MemUDQM   : OUT    STD_LOGIC;
  MemLDQM   : OUT    STD_LOGIC;
  MemData   : INOUT  std_logic_vector ( 15 DOWNTO 0 )
);
END COMPONENT memctrl ;



COMPONENT sdram_memctrl IS
PORT(   
  clock         : IN     std_logic;
  reset         : IN     std_logic;

  WE            : IN     std_logic;
  RE            : IN     std_logic;
  RW_ACK        : OUT    std_logic;
  R_READY       : OUT    std_logic;
  ADDR          : IN     std_logic_vector ( 24 DOWNTO 0 );
  DATA_IN       : IN     std_logic_vector (  15 DOWNTO 0 );
  DATA_OUT      : OUT    std_logic_vector (  15 DOWNTO 0 );
  
  SDRAM_CLK     : OUT    std_logic;
  SDRAM_CKE     : OUT    std_logic;
  SDRAM_CS      : OUT    std_logic;
  SDRAM_RAS     : OUT    std_logic;
  SDRAM_CAS     : OUT    std_logic;
  SDRAM_WE      : OUT    std_logic;
  SDRAM_BA      : OUT    std_logic_vector (  1 DOWNTO 0 );
  SDRAM_ADDR    : OUT    std_logic_vector ( 12 DOWNTO 0 );
  SDRAM_DQMU    : OUT    std_logic;
  SDRAM_DQML    : OUT    std_logic;
  SDRAM_DATA    : INOUT  std_logic_vector ( 15 DOWNTO 0 )
);
END COMPONENT sdram_memctrl ;

------------------------------
-- Signals --------------------
------------------------------

signal clock,reset              : std_logic := '0';
signal reset_n,clock180          : std_logic;

signal cmd_wr        : std_logic := '0';
signal cmd_enable    : std_logic := '0';

signal SDRAM_CLK        : STD_LOGIC;
signal SDRAM_CKE        : STD_LOGIC;
signal SDRAM_CS         : STD_LOGIC;
signal SDRAM_RAS        : STD_LOGIC;
signal SDRAM_CAS        : STD_LOGIC;
signal SDRAM_WE         : STD_LOGIC;
signal SDRAM_DQM        : STD_LOGIC_VECTOR( 1 downto 0);
signal SDRAM_DQM_bit    : std_logic;
signal SDRAM_ADDR       : STD_LOGIC_VECTOR(12 downto 0);
signal SDRAM_BA         : STD_LOGIC_VECTOR( 1 downto 0);
signal SDRAM_DATA       : STD_LOGIC_VECTOR(15 downto 0);

signal wr_enable        : std_logic := '0';
signal addr          : std_logic_vector(24 downto 0) := (others => '0');
signal wr_data          : std_logic_vector(15 downto 0) := (others => '0');

signal rd_addr          : std_logic_vector(23 downto 0) := (others => '0');
signal rd_enable,rw_ack        : std_logic := '0';

begin


    clock <= not (clock) after 5 ns;    --clock with time period 20 ns
    clock180 <= not clock;

    reset_n <= not reset;

    main : process is
    begin
        reset <= '1';
        wait until rising_edge(clock);
        wait until rising_edge(clock);
        reset <= '0';
        wait;
    end process main;


    test : process is
    begin
        wait for 205 us;
        wait until rising_edge(clock);
        

        for i in 0 to 9 loop
            addr <= std_logic_vector(to_signed(i, addr'length));
            wr_data <=  std_logic_vector(to_signed(i, wr_data'length));
            --addr <= x"00000000";
            wr_enable <= '1';
            wait until rising_edge(clock);
            wait until rw_ack='1';
            wr_enable <= '0';
            wait for 11.5 us;            
        end loop;



        wait for 12 us;
        wait until rising_edge(clock);


        for i in 0 to 9 loop
            addr <= std_logic_vector(to_signed(i, addr'length));
            rd_enable <= '1';
            wait until rising_edge(clock);
            wait until rw_ack='1';
            rd_enable <= '0';
            wait for 17 us;
        end loop;

        wait;


    end process test;



sdram_memctrl_i1 : sdram_memctrl
PORT MAP(   
  clock     => clock,
  reset     => reset,

  WE       => wr_enable,
  RE       => rd_enable,
  RW_ACK   => rw_ack,
  R_READY  => open,
  ADDR     => addr,
  DATA_IN  => wr_data,
  DATA_OUT => open,
  SDRAM_CLK     => SDRAM_CLK,
  SDRAM_CKE     => SDRAM_CKE,
  SDRAM_CS      => SDRAM_CS,
  SDRAM_RAS     => SDRAM_RAS,
  SDRAM_CAS     => SDRAM_CAS,
  SDRAM_WE      => SDRAM_WE,
  SDRAM_BA      => SDRAM_BA,
  SDRAM_ADDR    => SDRAM_ADDR,
  SDRAM_DQMU    => SDRAM_DQM(1),
  SDRAM_DQML    => SDRAM_DQM(0),
  SDRAM_DATA    => SDRAM_DATA
);



mt48lc16m16a2_i1  : mt48lc16m16a2
    PORT MAP (
        BA0     => SDRAM_BA(0),
        BA1     => SDRAM_BA(1),
        DQMH    => SDRAM_DQM(1),           
        DQML    => SDRAM_DQM(0),
        DQ0     => SDRAM_DATA(0),
        DQ1     => SDRAM_DATA(1), 
        DQ2     => SDRAM_DATA(2),
        DQ3     => SDRAM_DATA(3),
        DQ4     => SDRAM_DATA(4),
        DQ5     => SDRAM_DATA(5),
        DQ6     => SDRAM_DATA(6),
        DQ7     => SDRAM_DATA(7),
        DQ8     => SDRAM_DATA(8),
        DQ9     => SDRAM_DATA(9),
        DQ10    => SDRAM_DATA(10),
        DQ11    => SDRAM_DATA(11),
        DQ12    => SDRAM_DATA(12),
        DQ13    => SDRAM_DATA(13),
        DQ14    => SDRAM_DATA(14),
        DQ15    => SDRAM_DATA(15),
        CLK     => SDRAM_CLK,
        CKE     => SDRAM_CKE,
        A0      => SDRAM_ADDR(0),
        A1      => SDRAM_ADDR(1),
        A2      => SDRAM_ADDR(2),
        A3      => SDRAM_ADDR(3),
        A4      => SDRAM_ADDR(4),
        A5      => SDRAM_ADDR(5),
        A6      => SDRAM_ADDR(6),
        A7      => SDRAM_ADDR(7),
        A8      => SDRAM_ADDR(8),
        A9      => SDRAM_ADDR(9),
        A10     => SDRAM_ADDR(10),
        A11     => SDRAM_ADDR(11),
        A12     => SDRAM_ADDR(12),
        WENeg   => SDRAM_WE,
        RASNeg  => SDRAM_RAS,
        CSNeg   => SDRAM_CS,
        CASNeg  => SDRAM_CAS
    );



end Behavioral;
