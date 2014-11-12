CREATE TABLE [dbo].[Registro_Obito] (
    [cd_registro_obito]        INT          NOT NULL,
    [dt_registro_obito]        DATETIME     NULL,
    [cd_causa_obito]           INT          NULL,
    [cd_iml]                   INT          NULL,
    [cd_hospital]              INT          NULL,
    [cd_cliente]               INT          NULL,
    [nm_falecimento_reg_obito] VARCHAR (40) NULL,
    [dt_nascto_registro_obito] DATETIME     NULL,
    [dt_falecimento_reg_obito] DATETIME     NULL,
    [cd_tipo_registro_obito]   INT          NULL,
    [ds_registro_obito]        TEXT         NULL,
    [cd_tipo_sepultamento]     INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Registro_Obito] PRIMARY KEY CLUSTERED ([cd_registro_obito] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Obito_Tipo_Sepultamento] FOREIGN KEY ([cd_tipo_sepultamento]) REFERENCES [dbo].[Tipo_Sepultamento] ([cd_tipo_sepultamento])
);

