---------------------------------------------------------------------------
-- The AVR-Ada Library is free software;  you can redistribute it and/or --
-- modify it under terms of the  GNU General Public License as published --
-- by  the  Free Software  Foundation;  either  version 2, or  (at  your --
-- option) any later version.  The AVR-Ada Library is distributed in the --
-- hope that it will be useful, but  WITHOUT ANY WARRANTY;  without even --
-- the  implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR --
-- PURPOSE. See the GNU General Public License for more details.         --
--                                                                       --
-- As a special exception, if other files instantiate generics from this --
-- unit,  or  you  link  this  unit  with  other  files  to  produce  an --
-- executable   this  unit  does  not  by  itself  cause  the  resulting --
-- executable to  be  covered by the  GNU General  Public License.  This --
-- exception does  not  however  invalidate  any  other reasons why  the --
-- executable file might be covered by the GNU Public License.           --
---------------------------------------------------------------------------


package AVR.Interrupts is
   pragma Preelaborate (AVR.Interrupts);

   -- Enable interrupts
   procedure Sei;
   procedure Enable
     renames Sei;
   procedure Enable_Interrupts
     renames Sei;


   -- disable interrupts
   procedure Cli;
   procedure Disable
     renames Cli;
   procedure Disable_Interrupts
     renames Cli;

   --  save the status register and and disable interrupts
   function Save_And_Disable return Nat8;

   --  restore the status register, enables interrupts, if they were
   --  enabled at the time the status was saved.
   procedure Restore (Old_Status : Nat8);

   --  save the SREG register to a package local variable and disable
   --  interrupts
   procedure Save_Disable;
   --  restore the status register
   procedure Restore;


   --  return from interrupt
   --  (needed for the implementation of "naked" interrupts)
   -- procedure Return_From_Interrupt;

private

   pragma Inline (Sei);
   pragma Inline (Cli);

   pragma Inline_Always (Save_And_Disable);
   pragma Inline (Restore);

   -- pragma Inline_Always (Return_From_Interrupt);
   --  pragma No_Return (Return_From_Interrupt);

end AVR.Interrupts;
