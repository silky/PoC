-- EMACS settings: -*-  tab-width: 2; indent-tabs-mode: t -*-
-- vim: tabstop=2:shiftwidth=2:noexpandtab
-- kate: tab-width 2; replace-tabs off; indent-width 2;
-- 
-- ============================================================================
-- Authors:				 	Patrick Lehmann
-- 
-- Package:				 	Common primitives described as a function
--
-- Description:
-- ------------------------------------
--		This packages describes common primitives like flip flops and multiplexers
--		as a function to use them as one-liners.
--
-- License:
-- ============================================================================
-- Copyright 2007-2015 Technische Universitaet Dresden - Germany
--										 Chair for VLSI-Design, Diagnostics and Architecture
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--		http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- ============================================================================

library IEEE;
use			IEEE.STD_LOGIC_1164.all;
use			IEEE.NUMERIC_STD.all;

library PoC;
use			PoC.utils.all;


PACKAGE components IS
	-- implement an optional register stage
	function registered(signal Clock : STD_LOGIC; constant IsRegistered : BOOLEAN) return BOOLEAN;

	-- FlipFlop functions
	function ffdre(q : STD_LOGIC; d : STD_LOGIC; rst : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC;												-- D-FlipFlop with reset and enable
	function ffdre(q : STD_LOGIC_VECTOR; d : STD_LOGIC_VECTOR; rst : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR;	-- D-FlipFlop with reset and enable
	function ffdse(q : STD_LOGIC; d : STD_LOGIC; set : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC;												-- D-FlipFlop with set and enable
	function fftre(q : STD_LOGIC; rst : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC;																			-- T-FlipFlop with reset and enable
	function ffrs(q : STD_LOGIC; rst : STD_LOGIC := '0'; set : STD_LOGIC := '0') return STD_LOGIC;																			-- RS-FlipFlop with dominant rst
	function ffsr(q : STD_LOGIC; rst : STD_LOGIC := '0'; set : STD_LOGIC := '0') return STD_LOGIC;																			-- RS-FlipFlop with dominant set

	-- adder
	function inc(value : STD_LOGIC_VECTOR;	increment : NATURAL := 1) return STD_LOGIC_VECTOR;
	function inc(value : UNSIGNED;					increment : NATURAL := 1) return UNSIGNED;
	function inc(value : SIGNED;						increment : NATURAL := 1) return SIGNED;
	function dec(value : STD_LOGIC_VECTOR;	decrement : NATURAL := 1) return STD_LOGIC_VECTOR;
	function dec(value : UNSIGNED;					decrement : NATURAL := 1) return UNSIGNED;
	function dec(value : SIGNED;						decrement : NATURAL := 1) return SIGNED;

	-- negate
	function neg(value : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;		-- calculate 2's complement
	
	-- counter
	function upcounter_next(cnt : UNSIGNED; rst : STD_LOGIC; en : STD_LOGIC := '1'; init : NATURAL := 0) return UNSIGNED;
	function upcounter_equal(cnt : UNSIGNED; value : NATURAL) return STD_LOGIC;
	function downcounter_next(cnt : SIGNED; rst : STD_LOGIC; en : STD_LOGIC := '1'; init : INTEGER := 0) return SIGNED;
	function downcounter_equal(cnt : SIGNED; value : INTEGER) return STD_LOGIC;
	function downcounter_neg(cnt : SIGNED) return STD_LOGIC;

	-- shiftregisters
	function shreg_left(q : STD_LOGIC_VECTOR; i : STD_LOGIC; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR;
	function shreg_right(q : STD_LOGIC_VECTOR; i : STD_LOGIC; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR;
	-- rotate registers
	function rreg_left(q : STD_LOGIC_VECTOR; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR;
	function rreg_right(q : STD_LOGIC_VECTOR; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR;

	-- compare
	function comp(value1 : STD_LOGIC_VECTOR; value2 : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
	function comp(value1 : UNSIGNED; value2 : UNSIGNED) return UNSIGNED;
	function comp(value1 : SIGNED; value2 : SIGNED) return SIGNED;
	function comp_allzero(value	: STD_LOGIC_VECTOR)	return STD_LOGIC;
	function comp_allzero(value	: UNSIGNED)					return STD_LOGIC;
	function comp_allzero(value	: SIGNED)						return STD_LOGIC;
	function comp_allone(value	: STD_LOGIC_VECTOR)	return STD_LOGIC;
	function comp_allone(value	: UNSIGNED)					return STD_LOGIC;
	function comp_allone(value	: SIGNED)						return STD_LOGIC;
	
	-- multiplexing
	function mux(sel : STD_LOGIC; sl0		: STD_LOGIC;				sl1		: STD_LOGIC)				return STD_LOGIC;
	function mux(sel : STD_LOGIC; slv0	: STD_LOGIC_VECTOR;	slv1	: STD_LOGIC_VECTOR)	return STD_LOGIC_VECTOR;
	function mux(sel : STD_LOGIC; us0		: UNSIGNED;					us1		: UNSIGNED)					return UNSIGNED;
	function mux(sel : STD_LOGIC; s0		: SIGNED;						s1		: SIGNED)						return SIGNED;
end;


package body components is
	-- implement an optional register stage
	function registered(signal Clock : STD_LOGIC; constant IsRegistered : BOOLEAN) return BOOLEAN is
	begin
		return ite(IsRegistered, rising_edge(Clock), TRUE);
	end function;

	-- D-flipflop with reset and enable
	function ffdre(q : STD_LOGIC; d : STD_LOGIC; rst : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC is
	begin
		return ((d and en) or (q and not en)) and not rst;
	end function;
	
	function ffdre(q : STD_LOGIC_VECTOR; d : STD_LOGIC_VECTOR; rst : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR is
	begin
		return ((d and (q'range => en)) or (q and not (q'range => en))) and not (q'range => rst);
	end function;
	
	-- D-flipflop with set and enable
	function ffdse(q : STD_LOGIC; d : STD_LOGIC; set : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC is
	begin
		return ((d and en) or (q and not en)) or set;
	end function;
	
	-- T-flipflop with reset and enable
	function fftre(q : STD_LOGIC; rst : STD_LOGIC := '0'; en : STD_LOGIC := '1') return STD_LOGIC is
	begin
		return ((not q and en) or (q and not en)) and not rst;
	end function;
	
	-- RS-flipflop with dominant rst
	function ffrs(q : STD_LOGIC; rst : STD_LOGIC := '0'; set : STD_LOGIC := '0') return STD_LOGIC is
	begin
		return (q or set) and not rst;
	end function;
	
	-- RS-flipflop with dominant set
	function ffsr(q : STD_LOGIC; rst : STD_LOGIC := '0'; set : STD_LOGIC := '0') return STD_LOGIC is
	begin
		return (q and not rst) or set;
	end function;
	
	-- Adder
	function inc(value : STD_LOGIC_VECTOR; increment : NATURAL := 1) return STD_LOGIC_VECTOR is
	begin
		return std_logic_vector(inc(unsigned(value), increment));
	end function;
	
	function inc(value : UNSIGNED; increment : NATURAL := 1) return UNSIGNED is
	begin
		return value + increment;
	end function;

	function inc(value : SIGNED; increment : NATURAL := 1) return SIGNED is
	begin
		return value + increment;
	end function;
	
	function dec(value : STD_LOGIC_VECTOR; decrement : NATURAL := 1) return STD_LOGIC_VECTOR is
	begin
		return std_logic_vector(dec(unsigned(value), decrement));
	end function;
	
	function dec(value : UNSIGNED; decrement : NATURAL := 1) return UNSIGNED is
	begin
		return value + decrement;
	end function;

	function dec(value : SIGNED; decrement : NATURAL := 1) return SIGNED is
	begin
		return value + decrement;
	end function;
	
	-- negate
	function neg(value : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	begin
		return std_logic_vector(inc(unsigned(not value)));		-- 2's complement
	end function;
	
	-- Counter
	function upcounter_next(cnt : UNSIGNED; rst : STD_LOGIC; en : STD_LOGIC := '1'; init : NATURAL := 0) return UNSIGNED is
	begin
		if (rst = '1') then
			return to_unsigned(init, cnt'length);
		elsif (en = '1') then
			return cnt + 1;
		else
			return cnt;
		end if;
	end function;
	
	function upcounter_equal(cnt : UNSIGNED; value : NATURAL) return STD_LOGIC is
	begin
		-- optimized comparison for only up counting values
		return to_sl((cnt and to_unsigned(value, cnt'length)) = value);
	end function;
	
	function downcounter_next(cnt : SIGNED; rst : STD_LOGIC; en : STD_LOGIC := '1'; init : INTEGER := 0) return SIGNED is
	begin
		if (rst = '1') then
			return to_signed(init, cnt'length);
		elsif (en = '1') then
			return cnt - 1;
		else
			return cnt;
		end if;
	end function;
	
	function downcounter_equal(cnt : SIGNED; value : INTEGER) return STD_LOGIC is
	begin
		-- optimized comparison for only down counting values
		return to_sl((cnt nor to_signed(value, cnt'length)) /= value);
	end function;

	function downcounter_neg(cnt : SIGNED) return STD_LOGIC is
	begin
		return cnt(cnt'high);
	end function;	
	
	-- Shift/Rotate Registers
	function shreg_left(q : STD_LOGIC_VECTOR; i : std_logic; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR is
	begin
		return mux(en, q, q(q'left - 1 downto q'right) & i);
	end function;
	
	function shreg_right(q : STD_LOGIC_VECTOR; i : std_logic; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR is
	begin
		return mux(en, q, i & q(q'left downto q'right - 1));
	end function;
	
	function rreg_left(q : STD_LOGIC_VECTOR; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR is
	begin
		return mux(en, q, q(q'left - 1 downto q'right) & q(q'left));
	end function;
	
	function rreg_right(q : STD_LOGIC_VECTOR; en : STD_LOGIC := '1') return STD_LOGIC_VECTOR is
	begin
		return mux(en, q, q(q'right) & q(q'left downto q'right - 1));
	end function;
	
	-- compare functions
	-- return value 1- => value1 < value2 (difference is negative)
	-- return value 00 => value1 = value2 (difference is zero)
	-- return value -1 => value1 > value2 (difference is positive)
	function comp(value1 : STD_LOGIC_VECTOR; value2 : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	begin
		report "Comparing two STD_LOGIC_VECTORs - implicit conversion to UNSIGNED" severity WARNING;
		return std_logic_vector(comp(unsigned(value1), unsigned(value2)));
	end function;

	function comp(value1 : UNSIGNED; value2 : UNSIGNED) return UNSIGNED is
	begin
		if (value1 < value2) then
			return "10";
		elsif (value1 = value2) then
			return "00";
		else
			return "01";
		end if;
	end function;

	function comp(value1 : SIGNED; value2 : SIGNED) return SIGNED is
	begin
		if (value1 < value2) then
			return "10";
		elsif (value1 = value2) then
			return "00";
		else
			return "01";
		end if;
	end function;
	
	function comp_allzero(value	: STD_LOGIC_VECTOR) return STD_LOGIC is
	begin
		return comp_allzero(unsigned(value));
	end function;
	
	function comp_allzero(value	: UNSIGNED) return STD_LOGIC is
	begin
		return to_sl(value = (value'range => '0'));
	end function;
	
	function comp_allzero(value	: SIGNED) return STD_LOGIC is
	begin
		return to_sl(value = (value'range => '0'));
	end function;
	
	function comp_allone(value	: STD_LOGIC_VECTOR) return STD_LOGIC is
	begin
		return comp_allone(unsigned(value));
	end function;
	
	function comp_allone(value	: UNSIGNED) return STD_LOGIC is
	begin
		return to_sl(value = (value'range => '1'));
	end function;
	
	function comp_allone(value	: SIGNED) return STD_LOGIC is
	begin
		return to_sl(value = (value'range => '1'));
	end function;
	
	
	-- multiplexers
	function mux(sel : STD_LOGIC; sl0 : STD_LOGIC; sl1 : STD_LOGIC) return STD_LOGIC is
	begin
		return (sl0 and not sel) or (sl1 and sel);
	end function;
	
	function mux(sel : STD_LOGIC; slv0 : STD_LOGIC_VECTOR; slv1 : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	begin
		return (slv0 and not (slv0'range => sel)) or (slv1 and (slv1'range => sel));
	end function;

	function mux(sel : STD_LOGIC; us0 : UNSIGNED; us1 : UNSIGNED) return UNSIGNED is
	begin
		return (us0 and not (us0'range => sel)) or (us1 and (us1'range => sel));
	end function;
	
	function mux(sel : STD_LOGIC; s0 : SIGNED; s1 : SIGNED) return SIGNED is
	begin
		return (s0 and not (s0'range => sel)) or (s1 and (s1'range => sel));
	end function;
end package body;
