﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace ScriptDiff
{
    public class Program
    {
        static String SourceScriptFileName;
        static String OutputDir;
        static StreamReader script;
        static bool Silent = false;

        const string WELCOME = "This program helps on split a large database script, generated by SQL Server, into smallest files under output directory to helps individual comparation with WinMerge diff utility.\nUsage <Script.sql> <Output path> [/S]\n    /S - No show logs";
        const String BLOCK_ENTRY_STRING = "/****** Object:";

        public static int Main(string[] args)
        {
            if (args.Length < 2)
            {
                Console.WriteLine(WELCOME);
                return 0;
            }

            SourceScriptFileName = args[0];
            OutputDir = args[1];

            if (args.Length > 2)
                Silent = args[2] == "/s";

            String CurrentDir = Directory.GetCurrentDirectory();

            int counter = 0;
            String line;

            if (SourceScriptFileName.Length == 0 ||
                OutputDir.Length == 0 ||
                !File.Exists(SourceScriptFileName))
            {
                Console.Write(WELCOME);
                return 0;
            }

            if (SourceScriptFileName.Length == 0 || OutputDir.Length == 0)
            {
                Console.WriteLine("Usage <Database Script.sql> <Output path>");
                return 0;
            }

            script = new System.IO.StreamReader(SourceScriptFileName);

            line = script.ReadLine();

            while (line != null)
            {
                if (line.StartsWith(BLOCK_ENTRY_STRING))
                    line = GetScriptBlock(GetFile(line));
                else
                {
                    Console.WriteLine("Ignored line: " + line); 
                    line = script.ReadLine();
                }

                counter++;
            }

            script.Close();

            Console.WriteLine("\nDone !");
            Console.WriteLine(counter.ToString() + " block processed from " + SourceScriptFileName);
            return 1;
        }

        public static String GetScriptBlock(StreamWriter FileBlock)
        {
            String line = null;

            while ((line = script.ReadLine()) != null)
            {
                if (line.StartsWith(BLOCK_ENTRY_STRING))
                    break;

                FileBlock.WriteLine(line);
            }

            FileBlock.Close();

            return line;
        }

        public static StreamWriter GetFile(String Header)
        {
            String FileName = Header.Substring(BLOCK_ENTRY_STRING.Length, Header.IndexOf("Script Date") - BLOCK_ENTRY_STRING.Length).Trim().Replace(" ", ".") + ".sql";
            String DirectoryName = /*Directory.GetCurrentDirectory() + "\\" + */OutputDir;

            if (!Silent)
                Console.WriteLine("Processing script file: " + FileName);

            Directory.CreateDirectory(DirectoryName);
            StreamWriter FileBlock = new StreamWriter(DirectoryName + "\\" + FileName.Replace("\\", "_"));
            return FileBlock;
        }
    }
}
