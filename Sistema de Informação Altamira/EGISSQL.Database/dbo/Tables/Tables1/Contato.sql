CREATE TABLE [dbo].[Contato] (
    [dt_usuario]       DATETIME     NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [nm_contato]       VARCHAR (40) NOT NULL,
    [cd_cliente]       INT          NOT NULL,
    [cd_contato]       INT          NOT NULL,
    [sg_contato]       CHAR (10)    NULL,
    [nm_email_contato] VARCHAR (30) NULL,
    [cd_ddd]           CHAR (5)     NULL,
    [cd_telefone]      CHAR (10)    NULL,
    [cd_fax]           CHAR (10)    NULL,
    [cd_ramal]         CHAR (10)    NULL,
    [ic_mala_direta]   CHAR (1)     NULL,
    [cd_cargo]         INT          NULL,
    CONSTRAINT [PK_Contato] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_contato] ASC) WITH (FILLFACTOR = 90)
);

