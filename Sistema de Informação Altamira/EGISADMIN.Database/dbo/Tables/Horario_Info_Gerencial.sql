CREATE TABLE [dbo].[Horario_Info_Gerencial] (
    [cd_info_gerencial]      INT      NOT NULL,
    [cd_item_info_gerencial] INT      NOT NULL,
    [hr_info_gerencial]      CHAR (8) NOT NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Horario_Info_Gerencial] PRIMARY KEY CLUSTERED ([cd_info_gerencial] ASC, [cd_item_info_gerencial] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Horario_Info_Gerencial_Info_Gerencial] FOREIGN KEY ([cd_info_gerencial]) REFERENCES [dbo].[Info_Gerencial] ([cd_info_gerencial])
);

