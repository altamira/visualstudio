CREATE TABLE [dbo].[Cliente_Foco_Rel_Diario_Repnet] (
    [cd_cli_foco_rel_diario] INT          NOT NULL,
    [nm_foco_rel_diario]     VARCHAR (20) NULL,
    [sg_foco_rel_diario]     VARCHAR (15) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Foco_Rel_Diario_Repnet] PRIMARY KEY CLUSTERED ([cd_cli_foco_rel_diario] ASC) WITH (FILLFACTOR = 90)
);

