LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

-- We’ll start out with a basic state machine that implements both a Mealy and a Moore state
-- machine. Bear in mind that it is only the output process that differ between the two. The
-- “next state” process handling the state transitions is the same!
--
-- Hint! Start with just looking at the Moore output (Moo_out) and implement the
-- state machine to do this. When it works, create a Mealy output process to generate
-- the Mealy output (Mea_out). In VHDL, create a new “state” type to reflect the
-- three states: “idle”, “init” and “active (See section 10.4 in the book). This will make
-- your code more readable and state names will be visible in the simulation waveform
-- tool.
ENTITY three_process_fsm_template IS
	PORT
	(
		clk     : IN std_logic;
		input_a : IN std_logic;
		reset   : IN std_logic;
		moo_out : OUT std_logic;
	);
END three_process_fsm_template;

ARCHITECTURE three_processes OF three_process_fsm_template IS
	TYPE state IS (idle, init, active);
	SIGNAL present_state, next_state : state;
BEGIN

	state_reg : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset_bar = '0' THEN
				present_state <= < initial_state > ;
			ELSE
				present_state <= next_state;
			END IF;
		END IF;
	END PROCESS;

	outputs : PROCESS (present_state, < inputs >);
	BEGIN
		CASE present_state IS
				-- one case branch required for each state
			WHEN < state_value_i >= >
				IF < input_condition_1 > THEN
					-- assignments to outputs
				ELSIF < input_condition_2 > THEN
					-- assignments to outputs
				ELSE
					-- assignments to outputs;
				END IF;

				...

				-- default branch
			WHEN OTHERS =>
				-- assignments to outputs

		END CASE;
	END PROCESS;

	next_state : PROCESS (present_state, < inputs >);
	BEGIN
		next_state_inner <= present_state_inner; -- default decleration
		next_state_outer <= present_state_outer;-- default decleration
		CASE present_state IS

				-- one case branch required for each state
			WHEN < state_value_i >= >
				IF < input_condition_1 > THEN
					-- assignment to next_state
				ELSIF < input_condition_2 > THEN
					-- assignment to next_state
				ELSE
					-- assignment to next_state
				END IF;

				--...

				-- default branch
			WHEN OTHERS =>
				-- assign initial_state to next_state

		END CASE;
	END PROCESS;

END three_processes;