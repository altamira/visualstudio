using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace Altamira.Contabil.CONTMATIC
{
    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    public struct CourseRecType
    {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 8)]
        public string Name;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 51)]
        public string Description;
        public ushort Credit_Hours;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 21)]
        public string Dept_Name;

        public CourseRecType(string name, string desc, ushort hrs, string dept)
        {
            Credit_Hours = hrs;
            Name = name;
            Description = desc;
            Dept_Name = dept;
        }
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)] // Size=81
    public struct BTRCourseRecType
    {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 7)]
        public string Name;
        public byte DescriptionNull;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 50)]
        public string Description;
        public byte Credit_HoursNull;
        public ushort Credit_Hours;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 20)]
        public string Dept_Name;
    }

    // access modifier is default to private
    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)] // Size=8
    public struct GNE_HEADER
    {
        public short descriptionLen;
        /// <remark>
        /// Embedded array disabled Marshal.SizeOf and Marshal.PtrToStructure/Marshal.StructureToPtr
        /// </remark>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        public char[] currencyConst;
        public short rejectCount;
        public short numberTerms;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)] // Size=14
    public struct TERM_HEADER_NAME
    {
        public char fieldType;
        public short fieldLen;
        public short fieldOffset;
        public char comparisonCode;
        public char connector;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 7)]
        public char[] value;   // course name. Don't use string
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]  // Size=27
    public struct TERM_HEADER_DEPT
    {
        public char fieldType;
        public short fieldLen;
        public short fieldOffset;
        public char comparisonCode;
        public char connector;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
        public char[] value; // dept. name. Do not use string
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    public struct RETRIEVAL_HEADER
    {
        public short maxRecsToRetrieve;
        public short noFieldsToRetrieve;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    public struct FIELD_RETRIEVAL_HEADER
    {
        public short fieldLen;
        public short fieldOffset;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    public struct PRE_GNE_BUFFER_ADVANCED
    {
        public GNE_HEADER gneHeader;
        public TERM_HEADER_NAME term1;
        public TERM_HEADER_DEPT term2;
        public RETRIEVAL_HEADER retrieval;
        public FIELD_RETRIEVAL_HEADER recordRet;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    public struct PRE_GNE_BUFFER_DEPT
    {
        public GNE_HEADER gneHeader;
        public TERM_HEADER_DEPT term;
        public RETRIEVAL_HEADER retrieval;
        public FIELD_RETRIEVAL_HEADER recordRet;
    }

    // used to move content from unmanaged memory block to application structure
    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    public struct RETURN_REC
    {
        public short recLen;
        public int recPos;
        public BTRCourseRecType rec;
    }

    // used to move content from unmanaged memory block to application structure
    // recs is large enough to hold 10 records of RETURN_REC
    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    public struct POST_GNE_BUFFER
    {
        public short numReturned;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 900)]
        public char[] recs;
    }

    /// <summary>
    /// wrapper class of Win32 function, BTRCALL 
    /// </summary>
    public class PlanoContas
    {
        enum COURSE_FIELD
        {
            KEY0_LEN = 7,       // course name
            KEY1_LEN = 20,      // dept name
            DATA1_LEN = 50,     // description
            DATA2_LEN = 2,      // credit hour
        }

        // used to allocate unmanaged memory block and 
        // B_GET_NEXT_EXTENDED
        private const int MAX_REC = 10;

        private byte[] posBlock;
        private byte[] keyBuffer;
        private byte keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
        private uint dataLen, memorySz = 0;
        private char keyNum = (char)0;
        private IntPtr dataBuffer = IntPtr.Zero;
        private short bStat = 0;
        private bool fileOpened = false;
        private string fullFilePath = string.Empty;

        ///<summary>
        ///initialize the string builder capacity
        ///</summary>
        public PlanoContas()
        {
            //
            // TODO: Add constructor logic here
            //
            posBlock = new byte[(int)BTRCONSTS.POSBLK_LEN];
            keyBuffer = new byte[(int)BTRCONSTS.KEY_BUF_LEN];
        }

        ///<summary>
        ///destructor
        ///</summary>
        public void Finalize()
        {
            if (fileOpened == true)
            {
                ResetBTR();
                fileOpened = false;
                fullFilePath = string.Empty;
            }

            if (dataBuffer != IntPtr.Zero)
            {
                Marshal.FreeHGlobal(dataBuffer);
            }
        }

        ///<summary>
        ///popup a message box for a given message with specific icon.
        ///the box has only one button, OK.
        ///</summary>
        //private void //showExceptionMsg(string msg, string caption, MessageBoxIcon icon)
        //{
        //    MessageBox.Show(msg, caption, MessageBoxButtons.OK, icon);
        //}

        ///<summary>
        /// allocate a block of unmanaged memory to interface with Btrieve Win32 API
        /// to simplify the agorithm, we allocate the largest size we will need for
        /// this program
        ///</summary>
        ///<return>
        ///true if no error. Otherwise return false.
        ///</return>
        private bool alloc()
        {
            if (dataBuffer == IntPtr.Zero)
            {
                ///<remark>
                /// dataBuffer is multi-use. One is to simulate the C type 
                /// 
                ///typedef union
                ///{
                ///  PRE_GNE_BUFFER_ADVANCED  preBuf1;
                ///  PRE_GNE_BUFFER_DEPT      preBuf2;
                ///} PRE_GNE_BUFFER;
                ///
                ///typedef union 
                ///{ 
                ///  PRE_GNE_BUFFER  preBuf;
                ///  POST_GNE_BUFFER postBuf; 
                ///} GNE_BUFFER; 
                ///
                ///</remark>
                int len1 = Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
                //int len4 = 2 + len1 * MAX_REC; // 
                int len2 = Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.PRE_GNE_BUFFER_ADVANCED"));
                int len3 = Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.PRE_GNE_BUFFER_DEPT"));
                int len4 = Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.POST_GNE_BUFFER"));

                if (len4 >= len3 && len4 >= len2 && len4 >= len1)
                {
                    dataLen = (uint)len4;
                }
                else if (len3 >= len4 && len3 >= len2 && len3 >= len1)
                {
                    dataLen = (uint)len3;
                }
                else if (len2 >= len4 && len2 >= len3 && len2 >= len1)
                {
                    dataLen = (uint)len2;
                }
                else
                {
                    dataLen = (uint)len1;
                }

                memorySz = dataLen;
                try
                {
                    dataBuffer = Marshal.AllocHGlobal((int)dataLen);
                }
                catch (OutOfMemoryException e)
                {
                    ////showExceptionMsg(e.Message, "AllocaHGlobal Exception", MessageBoxIcon.Stop);
                    return false;
                }
            }

            return true;
        }

        ///<summary>
        ///read specific number of bytes starting at specific offset from unmanaged memory block
        ///</summary>
        ///<param>
        ///StringBuilder dest - store bytes read into string builder
        ///IntPtr offset      - source offset
        ///int sz             - number of bytes to read
        ///</param>
        private void readBytes(StringBuilder dest, int offset, int sz)
        {
            int idx;
            if (dest.Length > 0)
            {
                dest.Remove(0, dest.Length);
            }

            for (idx = 0; idx < sz; idx++)
            {
                dest.Append((char)(Marshal.ReadByte(dataBuffer, offset + idx)));
            }
        }

        ///<summary>
        ///read specific number of bytes starting at specific offset from unmanaged memory block
        ///</summary>
        ///<param>
        ///byte[] dest        - store bytes read into a byte array
        ///IntPtr offset      - source offset
        ///int sz             - number of bytes to read
        ///</param>
        private void readBytes(byte[] dest, int offset, int sz)
        {
            int idx = 0;

            for (idx = 0; idx < sz; idx++)
            {
                dest[idx] = Marshal.ReadByte(dataBuffer, offset + idx);
            }
        }

        ///<summary>
        ///write specific number of bytes to unmanaged memory block starting at specific offset 
        ///</summary>
        ///<param>
        ///StringBuilder src  - write bytes from string builder
        ///IntPtr offset      - destination offset
        ///int sz             - number of bytes to write
        ///</param>
        private void writeBytes(StringBuilder src, int offset, int sz)
        {
            int idx;
            int len = src.Length;

            for (idx = 0; idx < sz; idx++)
            {
                if (idx < len)
                {
                    Marshal.WriteByte(dataBuffer, offset + idx, (byte)(src[idx]));
                }
                else
                {
                    Marshal.WriteByte(dataBuffer, offset + idx, (byte)0);
                }
            }
        }

        ///<summary>
        ///write specific number of bytes to unmanaged memory block starting at specific offset 
        ///</summary>
        ///<param>
        ///byte[] dest        - write bytes from byte array
        ///IntPtr offset      - destination offset
        ///int sz             - number of bytes to write
        ///</param>
        private void writeBytes(byte[] dest, int offset, int sz)
        {
            int idx;

            for (idx = 0; idx < sz; idx++)
            {
                Marshal.WriteByte(dataBuffer, offset + idx, dest[idx]);
            }
        }

        ///<summary>
        ///move course data from unmanaged memory block into application data storage
        ///</summary>
        private void unpackData(ref CourseRecType course)
        {
            StringBuilder strBuf = new StringBuilder((int)COURSE_FIELD.DATA1_LEN + 1); // enought capacity

            readBytes(strBuf, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Name").ToInt32(), (int)COURSE_FIELD.KEY0_LEN);
            course.Name = strBuf.ToString();

            readBytes(strBuf, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Description").ToInt32(), (int)COURSE_FIELD.DATA1_LEN);
            course.Description = strBuf.ToString();

            readBytes(strBuf, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Dept_Name").ToInt32(), (int)COURSE_FIELD.KEY1_LEN);
            course.Dept_Name = strBuf.ToString();

            course.Credit_Hours = (ushort)Marshal.ReadInt16(dataBuffer, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Credit_Hours").ToInt32());
        }

        ///<summary>
        ///move course data from unmanaged memory block into application data storage
        ///</summary>
        ///<param>
        /// CourseRecType[] courses - array of CourseRecType
        /// ref int         sz      - in: current free index of courses, out: next free index of courses
        ///</param>
        private void unpackData(CourseRecType[] courses, ref int sz)
        {
            if (courses == null || courses.Length <= sz)
            {
                return;
            }

            short numReturned = Marshal.ReadInt16(dataBuffer);
            if (numReturned <= 0)
            {
                return;
            }

            // within each returned record,first two bytes are length while the next 4 bytes are record position
            int recOffset = Marshal.SizeOf(Type.GetType("System.Int32")) + Marshal.SizeOf(Type.GetType("System.Int16"));  // sizeof(short) + sizeof( int );
            StringBuilder strBuf = new StringBuilder((int)COURSE_FIELD.DATA1_LEN + 1); // enought capacity
            for (int idx = 0; idx < numReturned && sz < courses.Length; idx++, sz++)
            {
                // shift first two bytes that are number of records returned
                int offset = idx * Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.RETURN_REC")) + Marshal.SizeOf(Type.GetType("System.Int16")) + recOffset;
                readBytes(strBuf, offset + Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Name").ToInt32(), (int)COURSE_FIELD.KEY0_LEN);
                courses[sz].Name = strBuf.ToString();

                readBytes(strBuf, offset + Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Description").ToInt32(), (int)COURSE_FIELD.DATA1_LEN);
                courses[sz].Description = strBuf.ToString();

                readBytes(strBuf, offset + Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Dept_Name").ToInt32(), (int)COURSE_FIELD.KEY1_LEN);
                courses[sz].Dept_Name = strBuf.ToString();

                courses[sz].Credit_Hours = (ushort)Marshal.ReadInt16(dataBuffer, offset + Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Credit_Hours").ToInt32());
            }
        }

        ///<summary>
        ///move course data from application data storage to unmanaged memory block
        ///</summary>
        private void packData(CourseRecType course)
        {
            StringBuilder strBuf = new StringBuilder((int)(COURSE_FIELD.DATA1_LEN + 1)); // enought capacity
            strBuf.Append(course.Name);
            writeBytes(strBuf, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Name").ToInt32(), (int)COURSE_FIELD.KEY0_LEN);

            if (strBuf.Length > 0)
            {
                strBuf.Remove(0, strBuf.Length);
            }
            strBuf.Append(course.Description);
            writeBytes(strBuf, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Description").ToInt32(), (int)COURSE_FIELD.DATA1_LEN);

            Marshal.WriteInt16(dataBuffer, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Credit_Hours").ToInt32(), (short)course.Credit_Hours);

            if (strBuf.Length > 0)
            {
                strBuf.Remove(0, strBuf.Length);
            }
            strBuf.Append(course.Dept_Name);
            writeBytes(strBuf, Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Dept_Name").ToInt32(), (int)COURSE_FIELD.KEY1_LEN);

        }

        ///<summary>
        /// returned full path of file opened
        ///</summary>
        public string FileName
        {
            get
            {
                return fullFilePath;
            }
        }

        ///<summary>
        /// open specified Btrieve data file
        ///</summary>
        ///<param>
        ///string fn - full path of file
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool OpenBTRFile(string fn)
        {
            fileOpened = false;

            if (dataBuffer == IntPtr.Zero)
            {
                if (alloc() == false)
                {
                    return false;
                }
            }

            if (fn != string.Empty && fn.Length > 0)
            {
                if (fn.Equals(fullFilePath) == false)
                {
                    for (int i = 0; i < fn.Length; i++)
                    {
                        keyBuffer[i] = (byte)fn[i];
                    }
                }

                keyLen = (byte)fn.Length;
                keyNum = (char)0;
                dataLen = 0;
                bStat = 0;

                try
                {
                    bStat = Btrieve.BTRCALL((ushort)BTROPS.B_OPEN, posBlock, IntPtr.Zero, ref dataLen, keyBuffer, keyLen, keyNum);
                }
                catch (Exception ex)
                {
                    //showExceptionMsg(ex.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                    fullFilePath = string.Empty;
                    return false;
                }

                if (bStat == (short)BTRSTATUS.B_NO_ERROR)
                {
                    fileOpened = true;
                    fullFilePath = fn;
                    return true;
                }
                fullFilePath = string.Empty;
                //showExceptionMsg("B_OPEN - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            }

            return false;
        }

        ///<summary>
        /// open specified Btrieve data file
        ///</summary>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool CloseBTRFile()
        {
            fullFilePath = string.Empty;

            if (fileOpened == false)
            {
                // nothing to do
                return true;
            }

            keyLen = 0;
            keyNum = (char)0;
            dataLen = 0;
            bStat = 0;
            fileOpened = false;
            posBlock.Initialize();
            keyBuffer.Initialize();
            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_CLOSE, posBlock, IntPtr.Zero, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
            }

            if (bStat != (short)BTRSTATUS.B_NO_ERROR)
            {
                //showExceptionMsg("B_CLOSE - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            }

            // ignore this error 
            return true;
        }

        ///<summary>
        ///Release all BTR resources held by this client
        ///</summary>
        public bool ResetBTR()
        {
            keyLen = 0;
            keyNum = (char)0;
            dataLen = 0;
            bStat = 0;
            fileOpened = false;
            fullFilePath = string.Empty;
            posBlock.Initialize();
            keyBuffer.Initialize();
            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_RESET, posBlock, IntPtr.Zero, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Stop);
            }

            return true;
        }

        ///<summary>
        /// get Btrieve engine version for the file opened so that we can get engine and requester version
        ///</summary>
        ///<param>
        /// BTR_VERSION ver - data storage instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool GetBTRVersion(string fn, ref BTR_VERSION ver)
        {
            bStat = 0;

            if (fn == string.Empty || fn.Length == 0)
            {
                return false;
            }

            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTR_VERSION"));
            keyBuffer.Initialize();
            for (int i = 0; i < fn.Length; i++)
            {
                keyBuffer[i] = (byte)fn[i];
            }
            keyLen = (byte)fn.Length;
            keyNum = (char)0;

            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_VERSION, posBlock, ref ver, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                // we do need to move data around since we no longer used actual data storage
                return true;
            }

            //showExceptionMsg("B_VERSION - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// get the open Btrieve data file status information
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool GetBTRStatus(ref BTR_FILE_STATS stats, short key)
        {
            bStat = 0;
            if (fileOpened == false)
            {
                return false;
            }

            // work around of embedded array of structure type 
            dataLen = (ushort)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTR_FILE_STATS"));
            keyLen = 0;
            keyNum = (char)key;

            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_STAT, posBlock, ref stats, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                // no need to unpack since we used actual data storage
                return true;
            }

            //showExceptionMsg("B_STATUS - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// get first logic record along key0 path
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool GetBTRFirstRec(ref CourseRecType course)
        {
            bStat = 0;
            ///<remark>
            /// file must be open and caller has to allocate storage
            ///</remark>
            if (fileOpened == false)
            {
                return false;
            }

            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
            keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
            keyNum = (char)0;

            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_FIRST, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                unpackData(ref course);
                return true;
            }

            //showExceptionMsg("B_GET_FIRST - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// get next logic record along key0 path
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool GetBTRNextRec(ref CourseRecType course)
        {
            bStat = 0;
            if (fileOpened == false)
            {
                return false;
            }

            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
            keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
            keyNum = (char)0;

            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_NEXT, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                unpackData(ref course);
                return true;
            }

            //showExceptionMsg("B_GET_NEXT - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// get previous logic record along key0 path
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool GetBTRPreviousRec(ref CourseRecType course)
        {
            bStat = 0;
            if (fileOpened == false)
            {
                return false;
            }

            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
            keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
            keyNum = (char)0;

            try
            {

                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_PREVIOUS, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                unpackData(ref course);
                return true;
            }

            //showExceptionMsg("B_GET_PREVIOUS - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;

        }

        ///<summary>
        /// get last logic record along key0 path
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool GetBTRLastRec(ref CourseRecType course)
        {
            bStat = 0;
            if (fileOpened == false)
            {
                return false;
            }

            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
            keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
            keyNum = (char)0;

            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_LAST, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                unpackData(ref course);
                return true;
            }

            //showExceptionMsg("B_GET_LAST - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// insert a new record along key0 path
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool InsertBTRRec(CourseRecType course)
        {
            bStat = 0;
            if (fileOpened == false)
            {
                return false;
            }

            dataLen = 0;
            keyLen = 0;
            keyNum = (char)0;
            byte[] nullPos = new byte[(int)BTRCONSTS.POSBLK_LEN];
            byte[] nullKey = new byte[(int)BTRCONSTS.KEY_BUF_LEN];
            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_BEGIN_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
                if (bStat == (short)BTRSTATUS.B_NO_ERROR)
                {
                    dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
                    keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
                    packData(course);
                    bStat = Btrieve.BTRCALL((ushort)BTROPS.B_INSERT, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
                }
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
            }

            dataLen = 0;
            keyLen = 0;

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                Btrieve.BTRCALL((ushort)BTROPS.B_END_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
                return true;
            }

            Btrieve.BTRCALL((ushort)BTROPS.B_ABORT_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
            //showExceptionMsg("B_INSERT - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// update the current record
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool UpdateBTRRec(CourseRecType course)
        {
            bStat = 0;
            if (fileOpened == false)
            {
                return false;
            }

            dataLen = 0;
            keyLen = 0;
            keyNum = (char)0;
            byte[] nullPos = new byte[(int)BTRCONSTS.POSBLK_LEN];
            byte[] nullKey = new byte[(int)BTRCONSTS.KEY_BUF_LEN];
            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_BEGIN_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
                if (bStat == (short)BTRSTATUS.B_NO_ERROR)
                {
                    dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
                    keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
                    packData(course);
                    bStat = Btrieve.BTRCALL((ushort)BTROPS.B_UPDATE, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
                }
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
            }

            dataLen = 0;
            keyLen = 0;

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                Btrieve.BTRCALL((ushort)BTROPS.B_END_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
                return true;
            }

            Btrieve.BTRCALL((ushort)BTROPS.B_ABORT_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
            //showExceptionMsg("B_UPDATE - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// delete the current record
        ///</summary>
        ///<param>
        ///CourseRecType course - course record instantiated by caller
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool DeleteBTRRec()
        {
            bStat = 0;
            if (fileOpened == false)
            {
                return false;
            }

            dataLen = 0;
            keyLen = 0;
            keyNum = (char)0;
            byte[] nullPos = new byte[(int)BTRCONSTS.POSBLK_LEN];
            byte[] nullKey = new byte[(int)BTRCONSTS.KEY_BUF_LEN];
            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_BEGIN_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
                if (bStat == (short)BTRSTATUS.B_NO_ERROR)
                {
                    keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
                    bStat = Btrieve.BTRCALL((ushort)BTROPS.B_DELETE, posBlock, IntPtr.Zero, ref dataLen, keyBuffer, keyLen, keyNum);
                }
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
            }

            dataLen = 0;
            keyLen = 0;

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                Btrieve.BTRCALL((ushort)BTROPS.B_END_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
                return true;
            }

            Btrieve.BTRCALL((ushort)BTROPS.B_ABORT_TRAN, nullPos, IntPtr.Zero, ref dataLen, nullKey, keyLen, keyNum);
            //showExceptionMsg("B_DELETE - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// perform search function based on the search criteria, course name.
        ///</summary>
        ///<param>
        /// string courseName    - the name of the course which to be searched
        /// CourseRecType course - course record instantiated by caller. Since course name is Primary Key
        ///                        this search returns one and only one record
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool FindBTRRec(string cond, ref CourseRecType course)
        {
            bStat = 0;
            if (fileOpened == false || cond == null || cond == string.Empty)
            {
                return false;
            }

            for (int i = 0; i < keyBuffer.Length; i++)
            {
                keyBuffer[i] = (byte)20;
            }
            keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
            keyNum = (char)0;
            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));

            try
            {
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_FIRST + 50, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
                if (bStat == (short)BTRSTATUS.B_NO_ERROR)
                {
                    for (int i = 0; i < cond.Length; i++)
                    {
                        keyBuffer[i] = (byte)cond[i];
                    }
                    keyLen = (byte)cond.Length;

                    bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_EQUAL + 50, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
                    if (bStat == (short)BTRSTATUS.B_NO_ERROR)
                    {
                        bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_EQUAL, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);
                    }
                }
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR)
            {
                unpackData(ref course);
                return true;
            }

            //showExceptionMsg("Find by Course name - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// perform search function based on the search criteria,department name.
        ///</summary>
        ///<param>
        /// string dept          - the name of the department which to be searched
        /// CourseRecType course - course record instantiated by caller. Since a department may offer
        ///                        more than one course, an array of course records will be returned
        /// int           sz     - >0, number of results desired. Upon return, the actual result size
        ///                        will be returned
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool FindBTRRec(string dept, CourseRecType[] courses, ref int sz)
        {
            int i;
            short posCtr = 0;
            int numRet = sz;
            PRE_GNE_BUFFER_DEPT preBuf;

            // we had to initialize the embedded fixed length array
            preBuf.gneHeader.currencyConst = new char[2];
            preBuf.term.value = new char[(int)COURSE_FIELD.KEY1_LEN];
            for (i = 0; i < preBuf.term.value.Length; i++)
            {
                preBuf.term.value[i] = ' ';
            }
            bStat = 0;
            if (fileOpened == false || courses == null || courses.Length == 0 ||
                 sz <= 0 || courses.Length < sz || dept == null || dept == string.Empty)
            {
                return false;
            }

            sz = 0;
            for (i = 0; i < keyBuffer.Length; i++)
            {
                keyBuffer[i] = (byte)0;
            }
            keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
            keyNum = (char)1;
            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));

            try
            {
                /* Position to the 1st logical record to establish currency */
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_FIRST + 50, posBlock, IntPtr.Zero, ref dataLen, keyBuffer, keyLen, keyNum);

                // ToDo: zero out the data buffer
                // memset(&gneBuffer, 0, sizeof(GNE_BUFFER));

                // begin with the positioned record
                preBuf.gneHeader.currencyConst[0] = 'U';
                preBuf.gneHeader.currencyConst[1] = 'C';

                while (bStat == (short)BTRSTATUS.B_NO_ERROR && sz < numRet)
                {
                    preBuf.gneHeader.rejectCount = 0;  // Use MKDE defined default reject count
                    preBuf.gneHeader.numberTerms = 1;
                    posCtr = (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.GNE_HEADER"));

                    /* fill in the condition - dept name */
                    preBuf.term.fieldType = (char)0;                     // sting
                    preBuf.term.fieldLen = (short)COURSE_FIELD.KEY1_LEN;
                    preBuf.term.fieldOffset = (short)Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Dept_Name").ToInt32(); // 0 relative
                    preBuf.term.comparisonCode = (char)(1 + 128);  // string equal without case
                    preBuf.term.connector = (char)0;               // one term
                    dept.CopyTo(0, preBuf.term.value, 0, dept.Length);
                    posCtr += (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.TERM_HEADER_DEPT"));

                    /* fill in the projection header to retrieve course record, all fields */
                    if (numRet > MAX_REC)
                    {
                        preBuf.retrieval.maxRecsToRetrieve = MAX_REC;  // 10 per operation
                    }
                    else
                    {
                        preBuf.retrieval.maxRecsToRetrieve = (short)numRet;
                    }
                    preBuf.retrieval.noFieldsToRetrieve = 1;       // all fields
                    posCtr += (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.RETRIEVAL_HEADER"));

                    preBuf.recordRet.fieldLen = (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
                    preBuf.recordRet.fieldOffset = 0;
                    posCtr += (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.FIELD_RETRIEVAL_HEADER"));

                    preBuf.gneHeader.descriptionLen = posCtr;

                    // move our query structure into unmanaged memory block, and don't destroy our structure
                    Marshal.StructureToPtr(preBuf, dataBuffer, false);
                    dataLen = memorySz;
                    bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_NEXT_EXTENDED, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);

                    /* Get Next Extended can reach end of file and still return some records */
                    if (bStat == (short)BTRSTATUS.B_NO_ERROR || bStat == (short)BTRSTATUS.B_END_OF_FILE || bStat == (short)BTRSTATUS.B_OPTIMIZE_LIMIT_REACHED)
                    {
                        // move data to our structure
                        unpackData(courses, ref sz);

                        if (bStat != (short)BTRSTATUS.B_END_OF_FILE && bStat != (short)BTRSTATUS.B_OPTIMIZE_LIMIT_REACHED)
                        {
                            // to do: zero out our data buffer
                            // memset(&gneBuffer, 0, sizeof(GNE_BUFFER)); 
                            preBuf.gneHeader.currencyConst[0] = 'E';
                            preBuf.gneHeader.currencyConst[1] = 'G';
                        }
                    }
                }

            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR || sz > 0)
            {
                return true;
            }

            //showExceptionMsg("Find by Dept. Name - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }

        ///<summary>
        /// perform advanced search function based on the search criteria
        ///</summary>
        ///<param>
        /// string course        - the name of the course which is to be searched
        /// string dept          - the name of the department which is to be searched
        /// bool   useAnd        - true: course name AND dept name; otherwide OR
        /// CourseRecType courses- array of course record instantiated by caller.
        /// int           sz     - >0, number of results desired. Upon return, the actual result size
        ///                        will be returned
        ///</param>
        ///<return>
        ///true if no error. Otherwise return false
        ///</return>
        public bool FindBTRRec(string course, string dept, bool useAnd, CourseRecType[] courses, ref int sz)
        {
            int i;
            short posCtr = 0;
            int numRet = sz;  // store it
            char op = (char)2; // default to OR
            PRE_GNE_BUFFER_ADVANCED preBuf;

            preBuf.gneHeader.currencyConst = new char[2];
            preBuf.term1.value = new char[(int)COURSE_FIELD.KEY0_LEN];
            preBuf.term2.value = new char[(int)COURSE_FIELD.KEY1_LEN];

            for (i = 0; i < preBuf.term1.value.Length; i++)
            {
                preBuf.term1.value[i] = ' ';
            }
            for (i = 0; i < preBuf.term2.value.Length; i++)
            {
                preBuf.term2.value[i] = ' ';
            }

            bStat = 0;

            if (fileOpened == false || courses == null || courses.Length == 0 ||
                 sz <= 0 || courses.Length < sz ||
                 course == null || course == string.Empty || dept == null || dept == string.Empty)
            {
                return false;
            }

            sz = 0; // initialize it
            if (useAnd)
            {
                op = (char)1;
            }

            for (i = 0; i < keyBuffer.Length; i++)
            {
                keyBuffer[i] = (byte)0;
            }
            keyLen = (byte)BTRCONSTS.KEY_BUF_LEN;
            keyNum = (char)0;
            dataLen = (uint)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));

            try
            {
                /* Position to the 1st logical record to establish currency */
                bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_FIRST + 50, posBlock, IntPtr.Zero, ref dataLen, keyBuffer, keyLen, keyNum);

                // ToDo: zero out the data buffer
                // memset(&gneBuffer, 0, sizeof(GNE_BUFFER));

                // begin with the positioned record
                preBuf.gneHeader.currencyConst[0] = 'U';
                preBuf.gneHeader.currencyConst[1] = 'C';

                while (bStat == (short)BTRSTATUS.B_NO_ERROR && sz < numRet)
                {
                    preBuf.gneHeader.rejectCount = 0;  // Use MKDE defined default reject count
                    preBuf.gneHeader.numberTerms = 2;
                    posCtr = (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.GNE_HEADER"));

                    /* fill in the first condition - course name */
                    preBuf.term1.fieldType = (char)0;                     // sting
                    preBuf.term1.fieldLen = (short)COURSE_FIELD.KEY0_LEN;
                    preBuf.term1.fieldOffset = (short)Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Name").ToInt32(); // 0 relative
                    preBuf.term1.comparisonCode = (char)(1 + 128);  // string equal without case
                    preBuf.term1.connector = op;                    // next term based on useAnd
                    course.CopyTo(0, preBuf.term1.value, 0, course.Length);
                    posCtr += (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.TERM_HEADER_NAME"));

                    /* fill in the second condition  - dept. name */
                    preBuf.term2.fieldType = (char)0;      // integer
                    preBuf.term2.fieldLen = (short)COURSE_FIELD.KEY1_LEN;
                    preBuf.term2.fieldOffset = (short)Marshal.OffsetOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"), "Dept_Name").ToInt32(); // 0 relative
                    preBuf.term2.comparisonCode = (char)(1 + 128);  // string equal without case
                    preBuf.term2.connector = (char)0;               // no more
                    dept.CopyTo(0, preBuf.term2.value, 0, dept.Length);
                    posCtr += (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.TERM_HEADER_DEPT"));

                    /* fill in the projection header to retrieve course record, all fields */
                    if (numRet < MAX_REC)
                    {
                        preBuf.retrieval.maxRecsToRetrieve = (short)numRet;
                    }
                    else
                    {
                        preBuf.retrieval.maxRecsToRetrieve = MAX_REC;  // default to 10/per operation
                    }
                    preBuf.retrieval.noFieldsToRetrieve = 1;          // all fields
                    posCtr += (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.RETRIEVAL_HEADER"));

                    preBuf.recordRet.fieldLen = (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.BTRCourseRecType"));
                    preBuf.recordRet.fieldOffset = 0;
                    posCtr += (short)Marshal.SizeOf(Type.GetType("Altamira.Contabil.CONTMATIC.FIELD_RETRIEVAL_HEADER"));

                    preBuf.gneHeader.descriptionLen = posCtr;

                    // move our query structure into unmanaged memory block, and don't destroy our structure
                    Marshal.StructureToPtr(preBuf, dataBuffer, false);
                    dataLen = memorySz;
                    bStat = Btrieve.BTRCALL((ushort)BTROPS.B_GET_NEXT_EXTENDED, posBlock, dataBuffer, ref dataLen, keyBuffer, keyLen, keyNum);

                    /* Get Next Extended can reach end of file and still return some records */
                    if (bStat == (short)BTRSTATUS.B_NO_ERROR || bStat == (short)BTRSTATUS.B_END_OF_FILE || bStat == (short)BTRSTATUS.B_OPTIMIZE_LIMIT_REACHED)
                    {
                        // move data to our structure
                        unpackData(courses, ref sz);

                        if (bStat != (short)BTRSTATUS.B_END_OF_FILE && bStat != (short)BTRSTATUS.B_OPTIMIZE_LIMIT_REACHED)
                        {
                            // to do: zero out our data buffer
                            // memset(&gneBuffer, 0, sizeof(GNE_BUFFER));					   
                            preBuf.gneHeader.currencyConst[0] = 'E';
                            preBuf.gneHeader.currencyConst[1] = 'G';
                        }
                    }
                }
            }
            catch (Exception e)
            {
                //showExceptionMsg(e.Message, "BTRCALL Exception", MessageBoxIcon.Error);
                return false;
            }

            if (bStat == (short)BTRSTATUS.B_NO_ERROR || sz > 0)
            {
                return true;
            }

            //showExceptionMsg("Advanced search - Btrieve code: " + bStat, "BTRCALL Error", MessageBoxIcon.Error);
            return false;
        }
    }
}
