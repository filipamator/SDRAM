LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.NUMERIC_STD.all;


ENTITY sdram_memctrl IS
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
END ENTITY sdram_memctrl ;


ARCHITECTURE rtl OF sdram_memctrl IS



-- main state machine
TYPE mem_crtl_state_t IS (Wait_200us, InitPreCh, InitARref, InitLMReg, Read, Idle, Refresh, WaitState);
SIGNAL state : mem_crtl_state_t;
SIGNAL next_state : mem_crtl_state_t;

-- state for SDRAM command decoding
TYPE sdram_cmd_t IS (INHIBIT, NOP, ACTIVATE, READ, WRITE, PRECHARGE, AUTO_REFRESH, LOAD_MODE_REGISTER);
SIGNAL sdram_cmd : sdram_cmd_t;



CONSTANT c_ARef_Max     : natural := 765; -- 770
CONSTANT c_Delay_200us  : natural := 20000;


SIGNAL s_SDRAM_BA       : std_logic_vector(1 DOWNTO 0);
SIGNAL s_SDRAM_ADDR     : std_logic_vector(12 DOWNTO 0);
signal s_SDRAM_DATA     : std_logic_vector(15 DOWNTO 0);
SIGNAL s_SDRAM_OE       : std_logic;

SIGNAL s_ARef_En        : std_logic;

SIGNAL s_ARef_Counter                 : integer range 0 to c_ARef_Max;
SIGNAL s_ARef_Flag          : std_logic := '0';
SIGNAL s_ARef_Flag_prev     : std_logic := '0';


SIGNAL s_counter        : integer := 0;
SIGNAL s_wait_counter   : integer := 0;

SIGNAL s_IsRowAct       : std_logic := '0';
SIGNAL s_ActAddr        : std_logic_vector(14 DOWNTO 0);
SIGNAL s_SDRAM_DQM      : std_logic_vector(1 downto 0);

BEGIN


    SDRAM_CLK <= clock;
    SDRAM_CKE <= '1';
    SDRAM_DATA <= s_SDRAM_DATA WHEN s_SDRAM_OE = '1' ELSE "ZZZZZZZZZZZZZZZZ";  


    PROCESS(reset,clock)
    BEGIN

        IF (reset='1') THEN
            s_ARef_En <= '0';
            state <= Wait_200us;
            s_counter <= 0;
            RW_ACK <= '0';
            R_READY <= '0';
            DATA_OUT <= (others => '0');
            s_ARef_Flag <= '0';
            s_ARef_Flag_prev <= '0';
            s_IsRowAct <= '0';
            s_SDRAM_BA <= (others => '0');
            s_SDRAM_ADDR <= (others => '0');
            s_SDRAM_OE <= '0';
            s_SDRAM_DATA <= (others => '0');
            s_SDRAM_DQM <= "11";
        ELSIF (clock='1' and clock'event) THEN

            IF s_ARef_En = '1' THEN
                IF (s_Aref_Counter = c_ARef_Max) THEN
                    s_Aref_Counter <= 0;
                    s_ARef_Flag <= not s_ARef_Flag;
                ELSE
                    s_Aref_Counter <= s_Aref_Counter + 1;
                END IF;
            END IF;

            --  
            sdram_cmd <= NOP;
            R_READY <= '0';
            RW_ACK <= '0';

            CASE state IS

                WHEN Wait_200us =>

                    IF (s_counter=c_Delay_200us) THEN
                        s_wait_counter <= 0;
                        state <= WaitState;
                        next_state <= InitPreCh;
                    ELSE
                        s_counter <= s_counter + 1;
                        sdram_cmd <= INHIBIT;
                    END IF;

                WHEN InitPreCh =>
                    sdram_cmd <= PRECHARGE;
                    s_SDRAM_ADDR(10) <= '1';    -- precharge all banks
                    s_counter <= 0;
                    s_wait_counter <= 1;
                    state <= WaitState;
                    next_state <= InitARref;

                WHEN InitARref =>
                    sdram_cmd <= AUTO_REFRESH;
                    s_counter <= s_counter + 1;
                    s_wait_counter <= 5;                -- tRFC
                    next_state <= InitARref;
                    state <= WaitState;
                    IF (s_counter=1) THEN
                        s_SDRAM_ADDR <= "0000000110000"; 
                        s_counter <= 0;
                        s_wait_counter <= 5;            -- tRFC
                        state <= WaitState;
                        next_state <= InitLMReg;
                    END IF;

                WHEN InitLMReg =>
                    sdram_cmd <= LOAD_MODE_REGISTER;
                    s_Aref_Counter <= 0;
                    s_ARef_En <= '1';
                    s_wait_counter <= 1;                -- tMRD
                    state <= WaitState;
                    next_state <= Idle;


                WHEN Refresh =>
                    sdram_cmd <= AUTO_REFRESH;
                    state <= WaitState;
                    s_wait_counter <= 5;                 -- tRFC
                    next_state <= Idle;

                WHEN Read =>
                    DATA_OUT <= SDRAM_DATA;
                    R_READY <= '1';
                    state <= Idle;


                WHEN WaitState =>
                    if (s_wait_counter=0) THEN
                        sdram_cmd <= NOP;
                        state <= next_state;
                    ELSE
                        sdram_cmd <= NOP; 
                        s_wait_counter <= s_wait_counter - 1;
                    END IF;

                WHEN Idle =>          --- Idle
                    
                    s_SDRAM_DQM <= "11";
                    s_SDRAM_OE <= '0';

                    IF (RE='1' or WE='1') THEN
                        IF (s_IsRowAct = '0') THEN
                            sdram_cmd <= ACTIVATE;
                            s_SDRAM_ADDR <= ADDR( 24 DOWNTO 12 ); -- row
                            s_SDRAM_BA   <= ADDR( 11 DOWNTO 10 ); -- bank
                            s_ActAddr    <= ADDR( 24 DOWNTO 10 );
                            s_IsRowAct <= '1';
                            s_wait_counter <= 1;                    -- tRCD
                            next_state <= Idle;
                            state <= WaitState;
                        ELSIF (s_ActAddr /= ADDR(24 DOWNTO 10)) THEN
                            sdram_cmd <= PRECHARGE;
                            s_SDRAM_ADDR(10) <= '0';
                            s_IsRowAct <= '0';
                            s_wait_counter <= 1;                    -- tRCD
                            next_state <= idle;
                            state <= WaitState;

                        ELSIF (WE='1') THEN
                            s_SDRAM_OE <= '1';
                            sdram_cmd <= WRITE;
                            s_SDRAM_DATA <= DATA_IN;
                            s_SDRAM_ADDR <= "000" & ADDR(9 DOWNTO 0);
                            s_SDRAM_DQM <= "00"; 
                            RW_ACK <= '1';
                            state <= Idle;
                        ELSE -- READ
                            s_SDRAM_ADDR <= "000" & ADDR(9 DOWNTO 0);
                            RW_ACK <= '1';
                            sdram_cmd <= READ;
                            s_SDRAM_DQM <= "00"; 
                            s_wait_counter <= 2;        -- CAS LATENCY = 3 
                            next_state <=  Read;
                            state <= WaitState;
                        END IF;

                    ELSIF (s_ARef_Flag /= s_ARef_Flag_prev) THEN

                        s_ARef_Flag_prev <= s_ARef_Flag;
                        IF (s_IsRowAct='1') THEN
                            sdram_cmd <= PRECHARGE;
                            s_SDRAM_ADDR(10) <= '0';
                            s_IsRowAct <= '0';
                            s_wait_counter <= 0;
                            state <= WaitState;
                            next_state <= Refresh;
                        ELSE 
                            sdram_cmd <= AUTO_REFRESH;
                            s_wait_counter <= 6;
                            next_state <= Idle;
                            state <= WaitState;
                        END IF;
                    END IF;

            END CASE;


        END IF;
    END PROCESS;


    PROCESS(clock,reset)
    BEGIN
        IF (reset='1') THEN
            SDRAM_CS    <= '1';
            SDRAM_RAS   <= '1';
            SDRAM_CAS   <= '1';
            SDRAM_WE    <= '1';
            SDRAM_BA    <= (others => '1');
            SDRAM_ADDR  <= (others => '1');
            SDRAM_DQMU  <= '1';
            SDRAM_DQML  <= '1';
        ELSIF (clock='0' and clock'event) THEN
            CASE sdram_cmd IS
                when INHIBIT =>
                    SDRAM_CS  <= '1'; 
                    SDRAM_RAS <= '1';
                    SDRAM_CAS <= '1';
                    SDRAM_WE  <= '1';
                when ACTIVATE =>
                    SDRAM_CS  <= '0'; 
                    SDRAM_RAS <= '0';
                    SDRAM_CAS <= '1';
                    SDRAM_WE  <= '1';                
                when READ =>
                    SDRAM_CS  <= '0'; 
                    SDRAM_RAS <= '1';
                    SDRAM_CAS <= '0';
                    SDRAM_WE  <= '1';
                when WRITE =>
                    SDRAM_CS  <= '0'; 
                    SDRAM_RAS <= '1';
                    SDRAM_CAS <= '0';
                    SDRAM_WE  <= '0';            
                when PRECHARGE =>
                    SDRAM_CS  <= '0'; 
                    SDRAM_RAS <= '0';
                    SDRAM_CAS <= '1';
                    SDRAM_WE  <= '0';
                when AUTO_REFRESH =>
                    SDRAM_CS  <= '0'; 
                    SDRAM_RAS <= '0';
                    SDRAM_CAS <= '0';
                    SDRAM_WE  <= '1';
                when LOAD_MODE_REGISTER =>
                    SDRAM_CS  <= '0'; 
                    SDRAM_RAS <= '0';
                    SDRAM_CAS <= '0';
                    SDRAM_WE  <= '0';
                when NOP =>              -- NOP
                    SDRAM_CS  <= '0'; 
                    SDRAM_RAS <= '1';
                    SDRAM_CAS <= '1';
                    SDRAM_WE  <= '1';
            END CASE;

            SDRAM_BA    <= s_SDRAM_BA;
            SDRAM_ADDR  <= s_SDRAM_ADDR;
            SDRAM_DQML  <= s_SDRAM_DQM(0);
            SDRAM_DQMU  <= s_SDRAM_DQM(1);

        END IF;
    END PROCESS;


END ARCHITECTURE rtl;