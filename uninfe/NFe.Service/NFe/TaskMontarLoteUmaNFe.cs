﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.IO;
using System.Xml;

using NFe.Components;
using NFe.Settings;
using NFe.Certificado;
using NFe.Exceptions;

namespace NFe.Service
{
    /// <summary>
    /// Executar as tarefas pertinentes a assinatura e montagem do lote de uma única nota fiscal eletrônica
    /// </summary>
    public class TaskMontarLoteUmaNFe : TaskAbst
    {
        public override void Execute()
        {
            try
            {
                int emp = new FindEmpresaThread(Thread.CurrentThread).Index;
                //AssinarValidarNFe(this, this.NomeArquivoXML, Empresa.Configuracoes[emp].PastaEnvio);
                this.AssinarValidarXMLNFe(Empresa.Configuracoes[emp].PastaEnvio);

                //Definir o nome do arquivo assinado
                FileInfo arq = new FileInfo(this.NomeArquivoXML);
                string arquivoAssinado = arq.DirectoryName.Substring(0, arq.DirectoryName.Length - 5) + Propriedade.NomePastaXMLAssinado + "\\" + arq.Name;

                //Montar lote de nfe
                FluxoNfe oFluxoNfe = new FluxoNfe();

                string cError = "";
                try
                {
                    DadosNFeClass oDadosNfe = this.LerXMLNFe(arquivoAssinado);
                    if (!oFluxoNfe.NFeComLote(oDadosNfe.chavenfe))
                    {
                        //Gerar lote
                        this.NomeArquivoXML = arquivoAssinado;
                        this.LoteNfe(arquivoAssinado);

                        //Definir o tipo do serviço
                        //Type tipoServico = this.GetType();
                        //tipoServico.InvokeMember("NomeArquivoXML", System.Reflection.BindingFlags.SetProperty, null, this, new object[] { arquivoAssinado });
                        //tipoServico.InvokeMember("LoteNfe", System.Reflection.BindingFlags.InvokeMethod, null, this, new object[] { arquivoAssinado });
                    }
                }
                catch (IOException ex)
                {
                    cError = (ex.InnerException != null ? ex.InnerException.Message : ex.Message);
                }
                catch (Exception ex)
                {
                    cError = (ex.InnerException != null ? ex.InnerException.Message : ex.Message);
                }

                ///
                /// danasa 9-2009
                /// 
                if (!string.IsNullOrEmpty(cError))
                {
                    try
                    {
                        ///
                        /// grava o arquivo de erro
                        /// 
                        oAux.GravarArqErroERP(Path.GetFileNameWithoutExtension(arquivoAssinado) + ".err", cError);
                        ///
                        /// move o arquivo para a pasta de erro
                        /// 
                        oAux.MoveArqErro(arquivoAssinado);
                    }
                    catch
                    {
                        //A principio não vou fazer nada Wandrey 24/04/2011
                    }
                }
            }
            catch { }
        }

    }
}
