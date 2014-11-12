CREATE TABLE [dbo].[Status_Plano_MRP] (
    [cd_status_plano_mrp] INT          NOT NULL,
    [nm_status_plano_mrp] VARCHAR (30) NULL,
    [sg_status_plano_mrp] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Status_Plano_MRP] PRIMARY KEY CLUSTERED ([cd_status_plano_mrp] ASC) WITH (FILLFACTOR = 90)
);

