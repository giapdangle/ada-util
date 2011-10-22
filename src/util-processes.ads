-----------------------------------------------------------------------
--  util-processes -- Process creation and control
--  Copyright (C) 2011 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
-----------------------------------------------------------------------
with Util.Streams;

with Ada.Finalization;
with Ada.Strings.Unbounded;
package Util.Processes is

   Invalid_State : exception;

   subtype String_Access is Ada.Strings.Unbounded.String_Access;

   type Argument_List is array (Positive range <>) of String_Access;

   type Process_Identifier is new Integer;

   type Process is limited private;

   --  Before launching the process, redirect the input stream of the process
   --  to the specified file.
   procedure Set_Input_Stream (Proc : in out Process;
                               File : in String);

   --  Set the output stream of the process
   procedure Set_Output_Stream (Proc : in out Process;
                                File : in String);

   --  Set the error stream of the process
   procedure Set_Error_Stream (Proc : in out Process;
                               File : in String);

   --  Set the working directory that the process will use once it is created.
   --  The directory must exist or the <b>Invalid_Directory</b> exception will be raised.
   procedure Set_Working_Directory (Proc : in out Process;
                                    Path : in String);

   --  Spawn a new process with the given command and its arguments.  The standard input, output
   --  and error streams are either redirected to a file or to a stream object.
   procedure Spawn (Proc      : in out Process;
                    Command   : in String;
                    Arguments : in Argument_List);

   --  Wait for the process to terminate.
   procedure Wait (Proc : in out Process);

   --  Get the process exit status.
   function Get_Exit_Value (Proc : in Process) return Integer;

   --  Get the process identifier.
   function Get_Pid (Proc : in Process) return Process_Identifier;

   --  Returns True if the process is running.
   function Is_Running (Proc : in Process) return Boolean;

   --  Get the process input stream allowing to write on the process standard input.
   function Get_Input_Stream (Proc : in Process) return Util.Streams.Output_Stream_Access;

   --  Get the process output stream allowing to read the process standard output.
   function Get_Output_Stream (Proc : in Process) return Util.Streams.Input_Stream_Access;

   --  Get the process error stream allowing to read the process standard output.
   function Get_Error_Stream (Proc : in Process) return Util.Streams.Input_Stream_Access;

private

   type Process is new Ada.Finalization.Limited_Controlled with record
      Dir        : Ada.Strings.Unbounded.Unbounded_String;
      In_File    : Ada.Strings.Unbounded.Unbounded_String;
      Out_File   : Ada.Strings.Unbounded.Unbounded_String;
      Err_File   : Ada.Strings.Unbounded.Unbounded_String;
      Pid        : Process_Identifier := -1;
      Exit_Value : Integer := -1;
      Output     : Util.Streams.Input_Stream_Access := null;
      Input      : Util.Streams.Output_Stream_Access := null;
      Error      : Util.Streams.Input_Stream_Access := null;
   end record;

   overriding
   procedure Finalize (Proc : in out Process);

end Util.Processes;
