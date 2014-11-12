CREATE TABLE [dbo].[Tipo_Pessoa] (
    [cd_tipo_pessoa]         INT          NOT NULL,
    [nm_tipo_pessoa]         VARCHAR (30) NOT NULL,
    [sg_tipo_pessoa]         CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [nm_mascara_tipo_pessoa] VARCHAR (25) NULL,
    [nm_rotina_verificacao]  VARCHAR (20) NULL,
    [ic_padrao_tipo_pessoa]  CHAR (1)     NULL,
    [cd_destinacao_produto]  INT          NULL,
    [ic_obrig_tipo_pessoa]   CHAR (1)     NULL,
    [sg_tipo_pessoa_cnab]    CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Pessoa] PRIMARY KEY CLUSTERED ([cd_tipo_pessoa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Pessoa_Destinacao_Produto] FOREIGN KEY ([cd_destinacao_produto]) REFERENCES [dbo].[Destinacao_Produto] ([cd_destinacao_produto])
);

