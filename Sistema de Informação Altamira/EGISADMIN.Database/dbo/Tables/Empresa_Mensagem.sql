CREATE TABLE [dbo].[Empresa_Mensagem] (
    [cd_empresa_mensagem]       INT          NOT NULL,
    [nm_empresa_mensagem]       VARCHAR (30) NOT NULL,
    [sg_empresa_mensagem]       CHAR (10)    NOT NULL,
    [ds_empresa_mensagem]       TEXT         NOT NULL,
    [ic_ativa_empresa_mensagem] CHAR (1)     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Empresa_Mensagem] PRIMARY KEY CLUSTERED ([cd_empresa_mensagem] ASC) WITH (FILLFACTOR = 90)
);

