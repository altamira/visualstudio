CREATE TABLE [dbo].[Arbitration_Clause] (
    [cd_arbitration_clause] INT       NOT NULL,
    [ds_arbitration_clause] TEXT      NULL,
    [cd_usuario]            INT       NULL,
    [dt_usuario]            DATETIME  NULL,
    [sg_arbitration_clause] CHAR (10) NULL,
    CONSTRAINT [PK_Arbitration_Clause] PRIMARY KEY CLUSTERED ([cd_arbitration_clause] ASC) WITH (FILLFACTOR = 90)
);

