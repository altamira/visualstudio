// Type: lybtrcom.Create
// Assembly: Ly000008, Version=5.0.0.0, Culture=neutral, PublicKeyToken=666697afb0e8e7b5
// MVID: 1D110809-DBFE-4AEC-A1DB-C2824EA241EF
// Assembly location: Z:\Ly000008.dll

using System;
using System.Collections;
using System.Runtime.InteropServices;
using System.Text;

namespace lybtrcom
{
  public class Create
  {
    private string glf_file_name;
    private short glf_record_length;
    private short glf_page_size;
    private short glf_number_of_indexes;
    private short glf_file_version;
    private short glf_file_flags;
    private short glf_duplicate_pointers;
    private short glf_allocation;
    private Hashtable glf_key_block_specification;
    private Hashtable glf_ACS_specification;

    public string File_name
    {
      get
      {
        return this.glf_file_name;
      }
      set
      {
        this.glf_file_name = value;
      }
    }

    public short Record_length
    {
      get
      {
        return this.glf_record_length;
      }
      set
      {
        this.glf_record_length = value;
      }
    }

    public short Page_size
    {
      get
      {
        return this.glf_page_size;
      }
      set
      {
        this.glf_page_size = value;
      }
    }

    public short Number_of_Indexes
    {
      get
      {
        return this.glf_number_of_indexes;
      }
      set
      {
        this.glf_number_of_indexes = value;
      }
    }

    public short File_version
    {
      get
      {
        return this.glf_file_version;
      }
      set
      {
        this.glf_file_version = value;
      }
    }

    public short File_flags
    {
      get
      {
        return this.glf_file_flags;
      }
      set
      {
        this.glf_file_flags = value;
      }
    }

    public short Duplicate_pointers
    {
      get
      {
        return this.glf_duplicate_pointers;
      }
      set
      {
        this.glf_duplicate_pointers = value;
      }
    }

    public short Allocation
    {
      get
      {
        return this.glf_allocation;
      }
      set
      {
        this.glf_allocation = value;
      }
    }

    public Hashtable Key_specification
    {
      get
      {
        return this.glf_key_block_specification;
      }
      set
      {
        this.glf_key_block_specification = value;
      }
    }

    public Hashtable Acs_specification
    {
      get
      {
        return this.glf_ACS_specification;
      }
      set
      {
        this.glf_ACS_specification = value;
      }
    }

    public Create()
    {
      this.glf_key_block_specification = new Hashtable();
      this.glf_ACS_specification = new Hashtable();
    }

    public short create()
    {
      IntPtr num1 = IntPtr.Zero;
      IntPtr num2 = IntPtr.Zero;
      int num3 = this.glf_key_block_specification != null ? this.glf_key_block_specification.Count : 0;
      int num4 = this.glf_ACS_specification != null ? this.glf_ACS_specification.Count : 0;
      short num5 = Convert.ToInt16(16 + 16 * num3 + 265 * num4);
      IntPtr num6 = Marshal.AllocHGlobal((int) num5);
      Marshal.WriteInt16(num6, 0, this.glf_record_length);
      Marshal.WriteInt16(num6, 2, this.glf_page_size);
      Marshal.WriteByte(num6, 4, Convert.ToByte(this.glf_number_of_indexes));
      Marshal.WriteByte(num6, 5, Convert.ToByte(this.glf_file_version));
      Marshal.WriteInt16(num6, 10, this.glf_file_flags);
      Marshal.WriteByte(num6, 12, Convert.ToByte(this.glf_duplicate_pointers));
      Marshal.WriteInt16(num6, 14, this.glf_allocation);
      int num7 = num3;
      Create.key_spec keySpec;
      for (short index = (short) 1; (int) index <= num7; ++index)
      {
        keySpec = (Create.key_spec) this.glf_key_block_specification[(object) index.ToString()];
        Marshal.WriteInt16(num6, (int) index * 16, keySpec.key_position);
        Marshal.WriteInt16(num6, (int) index * 16 + 2, keySpec.key_length);
        Marshal.WriteInt16(num6, (int) index * 16 + 4, keySpec.key_flags);
        Marshal.WriteByte(num6, (int) index * 16 + 10, Convert.ToByte(keySpec.extended_data_type));
        Marshal.WriteByte(num6, (int) index * 16 + 11, Convert.ToByte(keySpec.null_vallue));
        Marshal.WriteByte(num6, (int) index * 16 + 14, Convert.ToByte(keySpec.Man_assigned_key_nr));
        Marshal.WriteByte(num6, (int) index * 16 + 15, Convert.ToByte(keySpec.ACS_number));
      }
      int num8 = num4;
      for (short index1 = (short) 1; (int) index1 <= num8; ++index1)
      {
        keySpec = (Create.key_spec) this.glf_key_block_specification[(object) index1.ToString()];
        int num9 = this.glf_ACS_specification.Count - 1;
        for (short index2 = (short) 0; (int) index2 <= num9; ++index2)
        {
          string str = (string) this.glf_ACS_specification[(object) index1.ToString()];
          Marshal.WriteByte(num6, 16 + this.glf_key_block_specification.Count * 16 + ((int) index1 - 1) * 265 + (int) index2, Convert.ToByte(str[(int) index2 + 1]));
        }
      }
      short Opcode = (short) 14;
      byte[] Cursor = new byte[128];
      short DataBufferLength = num5;
      short KeyLength = Convert.ToInt16(this.glf_file_name.Length);
      IntPtr num10 = Marshal.AllocHGlobal((int) KeyLength);
      Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.glf_file_name), 0, num10, (int) KeyLength);
      short KeyNum = (short) -1;
      short num11 = Func.BTRCALL(Opcode, Cursor, num6, ref DataBufferLength, num10, KeyLength, KeyNum);
      Marshal.FreeHGlobal(num6);
      return num11;
    }

    public struct key_spec
    {
      public short key_position;
      public short key_length;
      public short key_flags;
      public short extended_data_type;
      public short null_vallue;
      public short Man_assigned_key_nr;
      public short ACS_number;
    }
  }
}
