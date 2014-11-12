CREATE TABLE [dbo].[Forum] (
    [cd_forum]                INT          NOT NULL,
    [nm_forum]                VARCHAR (60) NULL,
    [nm_fantasia_forum]       VARCHAR (15) NULL,
    [cd_pais]                 INT          NULL,
    [cd_estado]               INT          NULL,
    [cd_cidade]               INT          NULL,
    [cd_identifica_cep]       INT          NULL,
    [nm_endereco]             VARCHAR (60) NULL,
    [nm_complemento_endereco] VARCHAR (30) NULL,
    [cd_numero_endereco]      CHAR (10)    NULL,
    [nm_bairro]               VARCHAR (25) NULL,
    [ds_forum]                TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Forum] PRIMARY KEY CLUSTERED ([cd_forum] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Forum_Estado] FOREIGN KEY ([cd_estado]) REFERENCES [dbo].[Estado] ([cd_estado])
);

