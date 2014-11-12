CREATE TABLE [dbo].[Beneficiario] (
    [cd_beneficiario]       INT          NOT NULL,
    [nm_beneficiario]       VARCHAR (60) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_swift_beneficiario] VARCHAR (25) NULL,
    [ds_beneficiario]       TEXT         NULL,
    CONSTRAINT [PK_Beneficiario] PRIMARY KEY CLUSTERED ([cd_beneficiario] ASC) WITH (FILLFACTOR = 90)
);

