//------------------------------------------------------------------------------
// <copyright file="CSSqlClassFile.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Text;

namespace EmailConnector
{
    public class mailConfiguration
    {
        private string nomeHost;
        private int porta;
        private bool bSsl;
        private string usuario;
        private string senha;

        public string hostname
        {
            get
            {
                return nomeHost;
            }

            set
            {
                nomeHost = value;
            }
        }
        public int port
        {
            get
            {
                return porta;
            }

            set
            {
                porta = value;
            }
        }
        public bool useSsl
        {
            get
            {
                return bSsl;
            }
            set
            {
                bSsl = value;
            }
        }
        public string username
        {
            get
            {
                return usuario;
            }
            set
            {
                usuario = value;
            }
        }
        public string password
        {
            get
            {
                return senha;
            }

            set
            {
                senha = value;
            }
        }

        public mailConfiguration()
        {
            nomeHost = string.Empty;
            porta = int.MinValue;
            bSsl = false;
            usuario = string.Empty;
            senha = string.Empty;
        }

    }
}
