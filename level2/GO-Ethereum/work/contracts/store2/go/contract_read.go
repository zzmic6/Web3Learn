package main

import (
        "fmt"
        "log"

        "github.com/ethereum/go-ethereum/common"
        "github.com/ethereum/go-ethereum/ethclient"

        store "go-eherrum/work/contracts/store2" // for demo
)

func main() {
        client, err := ethclient.Dial("http://127.0.0.1:8545")
        if err != nil {
                log.Fatal(err)
        }

        address := common.HexToAddress("0xd9145CCE52D386f254917e481eB44e9943F39138")
        instance, err := store.NewStore(address, client)
        if err != nil {
                log.Fatal(err)
        }

        version, err := instance.Version(nil)
        if err != nil {
                log.Fatal(err)
        }

        fmt.Println(version) // "1.0"
}