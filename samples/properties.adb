-----------------------------------------------------------------------
--  properties -- Example of properties
--  Copyright (C) 2001, 2002, 2003, 2006, 2008, 2009, 2010 Stephane Carrez
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
with Ada.Text_IO;
with Ada.Exceptions;
with Util.Properties.Basic;

procedure Properties is

   use Util.Properties.Basic;

   Properties : Util.Properties.Manager;

   Count : Integer;
begin
   Properties.Load_Properties (Path => "samples/test.properties");

   Count := Integer_Property.Get (Properties, "test.count");
   Ada.Text_IO.Put_Line ("test.count = " & Integer'Image (Count));

   Count := Integer_Property.Get (Properties, "test.repeat");
   Ada.Text_IO.Put_Line ("test.repeat = " & Integer'Image (Count));

exception
   when E : Util.Properties.NO_PROPERTY =>
      Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (E));
end Properties;
