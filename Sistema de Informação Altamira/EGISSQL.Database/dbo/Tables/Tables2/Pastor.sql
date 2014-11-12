CREATE TABLE [dbo].[Pastor] (
    [cd_pastor]               INT           NOT NULL,
    [nm_pastor]               VARCHAR (50)  NULL,
    [nm_fantasia_pastor]      VARCHAR (15)  NULL,
    [cd_ddd_pastor]           CHAR (4)      NULL,
    [cd_fone_pastor]          VARCHAR (15)  NULL,
    [cd_celular_pastor]       VARCHAR (15)  NULL,
    [cd_pais]                 INT           NULL,
    [cd_estado]               INT           NULL,
    [cd_cidade]               INT           NULL,
    [nm_endereco_pastor]      VARCHAR (60)  NULL,
    [cd_numero_endereco]      VARCHAR (10)  NULL,
    [nm_complemento_endereco] VARCHAR (30)  NULL,
    [nm_bairro]               VARCHAR (25)  NULL,
    [cd_identifica_cep]       INT           NULL,
    [ds_pastor]               TEXT          NULL,
    [nm_foto_pastor]          VARCHAR (100) NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Pastor] PRIMARY KEY CLUSTERED ([cd_pastor] ASC) WITH (FILLFACTOR = 90)
);

