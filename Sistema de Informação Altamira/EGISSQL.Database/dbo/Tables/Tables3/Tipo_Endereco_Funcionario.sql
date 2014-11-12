CREATE TABLE [dbo].[Tipo_Endereco_Funcionario] (
    [cd_tipo_endereco]     INT          NOT NULL,
    [nm_tipo_endereco]     VARCHAR (40) NULL,
    [sg_tipo_endereco]     CHAR (10)    NULL,
    [ic_pad_tipo_endereco] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Endereco_Funcionario] PRIMARY KEY CLUSTERED ([cd_tipo_endereco] ASC) WITH (FILLFACTOR = 90)
);

