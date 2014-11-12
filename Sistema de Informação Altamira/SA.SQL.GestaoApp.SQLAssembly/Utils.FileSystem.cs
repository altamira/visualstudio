using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Collections;
using Microsoft.SqlServer.Server;

namespace Utils
{
    public partial class FileSystem
    {
        [SqlFunction(FillRowMethodName = "FillRow")]
        public static IEnumerable DirectoryList(string rootDir, string wildCard, bool subDirectories)
        {
            ArrayList rowsArray = new ArrayList(); // Already implements IEnumerable, so we don't have to

            DirectorySearch(rootDir, wildCard, subDirectories, rowsArray);

            return rowsArray;
        }

        private static void DirectorySearch(string directory, string wildCard, bool subDirectories, ArrayList rowsArray)
        {
            GetFiles(directory, wildCard, rowsArray);

            if (subDirectories)
            {
                foreach (string d in Directory.GetDirectories(directory))
                {
                    DirectorySearch(d, wildCard, subDirectories, rowsArray);
                }
            }
        }

        private static void GetFiles(string d, string wildCard, ArrayList rowsArray)
        {
            foreach (string f in Directory.GetFiles(d, wildCard))
            {
                FileInfo fi = new FileInfo(f);

                object[] column = new object[6];
                column[0] = fi.Name.Substring(0, fi.Name.Length - fi.Extension.Length);
                column[1] = fi.Extension;
                column[2] = fi.Length;
                column[3] = fi.CreationTime;
                column[4] = fi.LastWriteTime;
                column[5] = fi.DirectoryName;

                rowsArray.Add(column);
            }
        }

        private static void FillRow(Object obj, 
                                    out string FileName, 
                                    out string Extension,
                                    out long Length,
                                    out DateTime CreateDate, 
                                    out DateTime UpdateDate, 
                                    out string Directory)
        {
            object[] row = (object[])obj;

            FileName = (string)row[0];
            Extension = (string)row[1];
            Length = (long)row[2];
            CreateDate = (DateTime)row[3];
            UpdateDate = (DateTime)row[4];
            Directory = (string)row[5];
        }
    }
}


