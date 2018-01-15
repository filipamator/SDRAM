--------------------------------------
--                                  --
-- A simple SDRAM memory controller --
-- Burst lenght = 1, CL=3           --
--                                  --
--------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.NUMERIC_STD.all;


ENTITY sdram_memctrl IS
PORT(   
    clock         : IN     std_logic;
    reset         : IN     std_logic;

    -- host interface

    mem_we            : IN     std_logic;
    mem_re            : IN     std_logic;
    mem_rw_ack        : OUT    std_logic;
    mem_r_ready       : OUT    std_logic;
    mem_addr          : IN     std_logic_vector(24 DOWNTO 0);
    mem_data_in       : IN     std_logic_vector(15 DOWNTO 0);
    mem_data_out      : OUT    std_logic_vector(15 DOWNTO 0);
  
    -- sdram interface

    SDRAM_CLK     : OUT    std_logic;
    SDRAM_CKE     : OUT    std_logic;
    SDRAM_CS      : OUT    std_logic;
    SDRAM_RAS     : OUT    std_logic;
    SDRAM_CAS     : OUT    std_logic;
    SDRAM_WE      : OUT    std_logic;
    SDRAM_BA      : OUT    std_logic_vector(1 DOWNTO 0);
    SDRAM_ADDR    : OUT    std_logic_vector(12 DOWNTO 0);
    SDRAM_DQMU    : OUT    std_logic;
    SDRAM_DQML    : OUT    std_logic;
    SDRAM_DATA    : INOUT  std_logic_vector(15 DOWNTO 0)
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



CONSTANT c_ARef_Max     : natural := 765;       -- A refresh command is issed every 765 clock cycles (1 clock cycle 10 ns)
CONSTANT c_Delay_200us  : natural := 20000;     -- Delat at startup


SIGNAL s_SDRAM_BA       : std_logic_vector(1 DOWNTO 0);
SIGNAL s_SDRAM_ADDR     : std_logic_vector(12 DOWNTO 0);
signal s_SDRAM_DATA     : std_logic_vector(15 DOWNTO 0);
SIGNAL s_SDRAM_OE       : std_logic;

SIGNAL s_ARef_En        : std_logic;                            -- auto refresh flag

SIGNAL s_ARef_Counter   : integer range 0 to c_ARef_Max;        -- couter for auto refresh
SIGNAL s_ARef_Flag          : std_logic := '0';
SIGNAL s_ARef_Flag_prev     : std_logic := '0';


SIGNAL s_counter        : integer := 0;                         -- general purpose counter
SIGNAL s_wait_counter   : integer := 0;                         -- wait state couter

SIGNAL s_IsRowAct       : std_logic := '0';                     
SIGNAL s_ActAddr        : std_logic_vector(14 DOWNTO 0);        -- currently opened bank/row
SIGNAL s_SDRAM_DQM      : std_logic_vector(1 downto 0);

BEGIN


    SDRAM_CLK <= clock;
    SDRAM_CKE <= '1';
    SDRAM_DATA <= s_SDRAM_DATA WHEN s_SDRAM_OE = '1' ELSE "ZZZZZZZZZZZZZZZZ";       -- bi-dir bus


    PROCESS(reset,clock)
    BEGIN

        IF (reset='1') THEN
            s_ARef_En <= '0';
            state <= Wait_200us;
            s_counter <= 0;
            mem_rw_ack <= '0';
            mem_r_ready <= '0';
            mem_data_out <= (others => '0');
            s_ARef_Flag <= '0';
            s_ARef_Flag_prev <= '0';
            s_IsRowAct <= '0';
            s_SDRAM_BA <= (others => '0');
            s_SDRAM_ADDR <= (others => '0');
            s_SDRAM_OE <= '0';
            s_SDRAM_DATA <= (others => '0');
            s_SDRAM_DQM <= "11";
        ELSIF (clock='1' and clock'event) THEN

            -- auto refresh counter
            IF s_ARef_En = '1' THEN
                IF (s_Aref_Counter = c_ARef_Max) THEN
                    s_Aref_Counter <= 0;
                    s_ARef_Flag <= not s_ARef_Flag;
                ELSE
                    s_Aref_Counter <= s_Aref_Counter + 1;
                END IF;
            END IF;

            -- default command for SDRAM is NOP
            sdram_cmd <= NOP;
            mem_r_ready <= '0';
            mem_rw_ack <= '0';

            CASE state IS
                -- wait on startup
                WHEN Wait_200us =>
                    IF (s_counter=c_Delay_200us) THEN
                        s_wait_counter <= 0;
                        state <= WaitState;
                        next_state <= InitPreCh;
                    ELSE
                        s_counter <= s_counter + 1;
                        sdram_cmd <= INHIBIT;
                    END IF;
                -- precharge all banks
                WHEN InitPreCh =>
                    sdram_cmd <= PRECHARGE;
                    s_SDRAM_ADDR(10) <= '1';    -- precharge all banks
                    s_counter <= 0;
                    s_wait_counter <= 1;
                    state <= WaitState;
                    next_state <= InitARref;
                -- init auto refresh
                WHEN InitARref =>
                    sdram_cmd <= AUTO_REFRESH;
                    s_counter <= s_counter + 1;
                    s_wait_counter <= 5;                -- tRFC from the datasheet
                    next_state <= InitARref;
                    state <= WaitState;
                    IF (s_counter=1) THEN
                        s_SDRAM_ADDR <= "0000000110000";        -- mode register for memory, CL=3, burst length=1
                        s_counter <= 0;
                        s_wait_counter <= 5;            -- tRFC
                        state <= WaitState;
                        next_state <= InitLMReg;
                    END IF;
                -- load the register
                WHEN InitLMReg =>
                    sdram_cmd <= LOAD_MODE_REGISTER;
                    s_Aref_Counter <= 0;
                    s_ARef_En <= '1';
                    s_wait_counter <= 1;                -- tMRD
                    state <= WaitState;
                    next_state <= Idle;

                -- refresh command
                WHEN Refresh =>
                    sdram_cmd <= AUTO_REFRESH;
                    state <= WaitState;
                    s_wait_counter <= 5;                 -- tRFC
                    next_state <= Idle;
                -- read command
                WHEN Read =>
                    mem_data_out <= SDRAM_DATA;
                    mem_r_ready <= '1';
                    state <= Idle;

                -- a wait state; number of the cycles stored in s_wait_counter
                WHEN WaitState =>
                    if (s_wait_counter=0) THEN
                        sdram_cmd <= NOP;
                        state <= next_state;
                    ELSE
                        sdram_cmd <= NOP; 
                        s_wait_counter <= s_wait_counter - 1;
                    END IF;

                -- default state
                WHEN Idle =>          --- Idle
                    
                    s_SDRAM_DQM <= "11";
                    s_SDRAM_OE <= '0';

                    IF (mem_re='1' or mem_we='1') THEN
                        -- check if a bank/row is activated
                        IF (s_IsRowAct = '0') THEN
                            sdram_cmd <= ACTIVATE;
                            s_SDRAM_ADDR <= mem_addr( 24 DOWNTO 12 ); -- row
                            s_SDRAM_BA   <= mem_addr( 11 DOWNTO 10 ); -- bank
                            s_ActAddr    <= mem_addr( 24 DOWNTO 10 );
                            s_IsRowAct <= '1';
                            s_wait_counter <= 1;                    -- tRCD
                            next_state <= Idle;
                            state <= WaitState;
                        -- check if a proper bank/row
                        ELSIF (s_ActAddr /= mem_addr(24 DOWNTO 10)) THEN
                            sdram_cmd <= PRECHARGE;
                            s_SDRAM_ADDR(10) <= '0';
                            s_IsRowAct <= '0';
                            s_wait_counter <= 1;                    -- tRCD
                            next_state <= idle;
                            state <= WaitState;

                        ELSIF (mem_we='1') THEN
                            s_SDRAM_OE <= '1';
                            sdram_cmd <= WRITE;
                            s_SDRAM_DATA <= mem_data_in;
                            s_SDRAM_ADDR <= "000" & mem_addr(9 DOWNTO 0);
                            s_SDRAM_DQM <= "00"; 
                            mem_rw_ack <= '1';
                            state <= Idle;
                        ELSE -- READ
                            s_SDRAM_ADDR <= "000" & mem_addr(9 DOWNTO 0);
                            mem_rw_ack <= '1';
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


    -- all signals for memory are registered on falling edge of the clock

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