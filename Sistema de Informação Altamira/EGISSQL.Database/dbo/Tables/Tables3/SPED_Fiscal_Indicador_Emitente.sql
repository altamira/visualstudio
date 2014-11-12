CREATE TABLE [dbo].[SPED_Fiscal_Indicador_Emitente] (
    [cd_indicador_emitente] INT          NOT NULL,
    [nm_indicador_emitente] VARCHAR (40) NULL,
    [cd_sped_fiscal]        VARCHAR (15) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Indicador_Emitente] PRIMARY KEY CLUSTERED ([cd_indicador_emitente] ASC) WITH (FILLFACTOR = 90)
);

