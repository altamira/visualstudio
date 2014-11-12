CREATE TABLE [dbo].[OEM_Rel_Diario_Repnet] (
    [cd_oem_rel_diario] INT          NOT NULL,
    [nm_oem_rel_diario] VARCHAR (20) NULL,
    [sg_oem_rel_diario] VARCHAR (15) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_OEM_Rel_Diario_Repnet] PRIMARY KEY CLUSTERED ([cd_oem_rel_diario] ASC) WITH (FILLFACTOR = 90)
);

