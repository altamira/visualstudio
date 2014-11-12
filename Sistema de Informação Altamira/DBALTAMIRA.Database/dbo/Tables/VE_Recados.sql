CREATE TABLE [dbo].[VE_Recados] (
    [vere_Numero]              CHAR (11)     NOT NULL,
    [vere_Data]                DATETIME      NULL,
    [vere_Abreviado]           CHAR (40)     NULL,
    [vere_Nome]                VARCHAR (100) NULL,
    [vere_Endereco]            VARCHAR (100) NULL,
    [vere_EndNumero]           NCHAR (10)    NULL,
    [vere_EndComplemento]      NCHAR (10)    NULL,
    [vere_CEP]                 CHAR (10)     NULL,
    [vere_Bairro]              VARCHAR (50)  NULL,
    [vere_Cidade]              VARCHAR (50)  NULL,
    [vere_Estado]              CHAR (2)      NULL,
    [vere_Municipio]           CHAR (50)     NULL,
    [vere_DDD]                 CHAR (4)      NULL,
    [vere_Telefone]            CHAR (25)     NULL,
    [vere_Ramal]               NCHAR (10)    NULL,
    [vere_Contato]             VARCHAR (50)  NULL,
    [vere_ProcurarPor]         VARCHAR (25)  NULL,
    [vere_Departamento]        VARCHAR (20)  NULL,
    [vere_Representante]       CHAR (3)      NULL,
    [vere_Propaganda]          TINYINT       NULL,
    [vere_Produto]             TINYINT       NULL,
    [vere_Chamado]             TINYINT       NULL,
    [vere_Observacao]          VARCHAR (800) NULL,
    [vere_DDDFax]              CHAR (4)      NULL,
    [vere_NumeroFax]           CHAR (10)     NULL,
    [vere_EMail]               CHAR (50)     NULL,
    [vere_TipoDoRecado]        VARCHAR (40)  NULL,
    [vere_NumeroOrçamento]     CHAR (10)     NULL,
    [vere_PrazoDoRecado]       SMALLDATETIME NULL,
    [vere_CodSituaçãoDoRecado] SMALLINT      NULL,
    [vere_SituaçãoDoRecado]    VARCHAR (30)  NULL,
    [vere_Usuario]             CHAR (10)     NULL,
    [vere_TipoDoCliente]       CHAR (20)     NULL,
    [vere_Protocolo]           INT           NULL,
    [vere_Lock]                BINARY (8)    NULL,
    [ContactName1]             NVARCHAR (50) NULL,
    [Department1]              NVARCHAR (30) NULL,
    [Email1]                   NVARCHAR (50) NULL,
    [CountryID1]               INT           CONSTRAINT [DF_VE_Recados_CountryID1] DEFAULT ((1)) NOT NULL,
    [AreaCode1]                CHAR (2)      CONSTRAINT [DF_VE_Recados_AreaCode1] DEFAULT ('11') NULL,
    [Prefix1]                  CHAR (4)      NULL,
    [FoneNumber1]              CHAR (4)      NULL,
    [AccessCode1]              CHAR (8)      NULL,
    [FoneTypeID1]              INT           CONSTRAINT [DF_VE_Recados_FoneTypeID1] DEFAULT ((1)) NOT NULL,
    [Product]                  INT           NULL,
    [CriadoEm]                 DATETIME      CONSTRAINT [DF_VE_Recados_CriadoEm] DEFAULT (getdate()) NOT NULL,
    [AtualizadoEm]             DATETIME      NULL,
    [CriadoPor]                INT           CONSTRAINT [DF_VE_Recados_CriadoPor] DEFAULT ((0)) NOT NULL,
    [AlteradoPor]              INT           CONSTRAINT [DF_VE_Recados_AlteradoPor] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_VE_Recados] PRIMARY KEY CLUSTERED ([vere_Numero] ASC)
);


GO
CREATE TRIGGER [dbo].[UpdateRecado]
   ON  dbo.VE_Recados 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    IF NOT UPDATE(AtualizadoEm)
    BEGIN
		UPDATE VE_Recados SET AtualizadoEm = GETDATE() FROM inserted as i WHERE VE_Recados.vere_numero = i.vere_numero
    END

END
