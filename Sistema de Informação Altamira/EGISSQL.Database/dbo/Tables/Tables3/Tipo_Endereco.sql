CREATE TABLE [dbo].[Tipo_Endereco] (
    [cd_tipo_endereco]          INT          NOT NULL,
    [nm_tipo_endereco]          VARCHAR (30) NOT NULL,
    [sg_tipo_endereco]          CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_cobranca_tipo_endereco] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Endereco] PRIMARY KEY CLUSTERED ([cd_tipo_endereco] ASC) WITH (FILLFACTOR = 90)
);

