CREATE TABLE [dbo].[Tipo_Email] (
    [cd_tipo_email]            INT          NOT NULL,
    [nm_tipo_email]            VARCHAR (30) NULL,
    [sg_tipo_email]            CHAR (3)     NULL,
    [nm_tabela]                VARCHAR (30) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ds_mensagem_padrao_email] TEXT         NULL,
    [ic_tipo_envio_email]      CHAR (1)     NULL,
    [ic_deleta_tipo_email]     CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Email] PRIMARY KEY CLUSTERED ([cd_tipo_email] ASC) WITH (FILLFACTOR = 90)
);

