using System;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;

namespace GestaoApp.Models
{
    public class Document : Base
    {
        #region Attributes

        private string name;
        private string extension;
        private long length;
        private DateTime createdate;
        private DateTime lastupdate;
        private string directory;

        #endregion

        #region properties

        [DisplayAttribute(Name = "Nome")]
        public string Name
        {
            get
            {
                if (name == null)
                    name = "";
                return name;
            }
            set
            {
                if ((object.ReferenceEquals(this.name, value) != true))
                {
                    name = value;
                    OnPropertyChanged("Name");
                }
            }
        }

        //[DisplayAttribute(Name = "Extensão")]
        [DisplayAttribute(AutoGenerateField = false)]
        public string Extension
        {
            get
            {
                if (extension == null)
                    extension = "";
                return extension;
            }
            set
            {
                if ((object.ReferenceEquals(this.extension, value) != true))
                {
                    extension = value;
                    OnPropertyChanged("Extension");
                }
            }
        }

        //[DisplayAttribute(Name = "Tamanho")]
        [DisplayAttribute(AutoGenerateField = false)]
        public long Length
        {
            get
            {
                return length;
            }
            set
            {
                if ((object.ReferenceEquals(this.length, value) != true))
                {
                    length = value;
                    OnPropertyChanged("Length");
                }
            }
        }

        [DisplayAttribute(Name = "Criado em")]
        public DateTime CreateDate
        {
            get
            {
                if (createdate == null)
                    createdate = DateTime.Now;
                return createdate;
            }
            set
            {
                if ((object.ReferenceEquals(this.createdate, value) != true))
                {
                    createdate = value;
                    OnPropertyChanged("CreateDate");
                }
            }
        }

        [DisplayAttribute(Name = "Alterado em")]
        public DateTime LastUpdate
        {
            get
            {
                if (lastupdate == null)
                    lastupdate = DateTime.Now;
                return lastupdate;
            }
            set
            {
                if ((object.ReferenceEquals(this.lastupdate, value) != true))
                {
                    lastupdate = value;
                    OnPropertyChanged("LastUpdate");
                }
            }
        }

        //[DisplayAttribute(Name = "Diretório")]
        [DisplayAttribute(AutoGenerateField = false)]
        public string Directory
        {
            get
            {
                if (directory == null)
                    directory = "";
                return directory;
            }
            set
            {
                if ((object.ReferenceEquals(this.directory, value) != true))
                {
                    directory = value;
                    OnPropertyChanged("Directory");
                }
            }
        }

        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Document",
                        new XAttribute("Id", Id),
                        new XAttribute("Guid", Guid.ToString()),
                        new XElement("Name", Name.Trim()),
                        new XElement("Extension", Extension.Trim()),
                        new XElement("Length", Length.ToString()),
                        new XElement("Create", CreateDate.ToString()),
                        new XElement("LastUpdate", LastUpdate.ToString()),
                        new XElement("Directory", Directory.Trim()));
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Guid = value.Attribute("Guid") != null ? Guid.Parse(value.Attribute("Guid").Value) : Guid.NewGuid();
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";
                Extension = value.Element("Extension") != null ? value.Element("Extension").Value.Trim() : "";
                Length = value.Element("Length") != null ? long.Parse(value.Element("Length").Value.Trim()) : 0;
                CreateDate = value.Element("Create") != null ? DateTime.Parse(value.Element("Create").Value) : DateTime.Now;
                LastUpdate = value.Element("LastUpdate") != null ? DateTime.Parse(value.Element("LastUpdate").Value) : DateTime.Now;
                Directory = value.Element("Directory") != null ? value.Element("Directory").Value.Trim() : "";
            }
        }

        #endregion
    }
}
