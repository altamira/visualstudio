CREATE TABLE [dbo].[FN_PosBancaria] (
    [fnpb_Banco] CHAR (3)      NOT NULL,
    [fnpb_Data]  SMALLDATETIME NOT NULL,
    [fnpb_Valor] MONEY         NOT NULL,
    [fnpb_Lock]  BINARY (8)    NULL
);

