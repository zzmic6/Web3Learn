package main

import (
        "fmt"
        "github.com/ethereum/go-ethereum/common"
		"github.com/ethereum/go-ethereum/crypto"
)

func main() {
        address := common.HexToAddress("0x71c7656ec7ab88b098defb751b7401b5f6d8976f")

        fmt.Println(address.Hex())        // 0x71C7656EC7ab88b098defB751B7401B5f6d8976F
        fmt.Println(address.MarshalText()) // 0x00000000000000000000000071c7656ec7ab88b098defb751b7401b5f6d8976f
        fmt.Println(address.Bytes())      // [113 199 101 110 199 171 136 176 152 222 251 117 27 116 1 181 246 216 151 111]


		// 计算地址的 Keccak-256 哈希值
		// hash := addressHash(address)
		// hex := common.Bytes2Hex(hash.bytes)
		// fmt.Printf("Hash: %s\n", hash)

}

// addressHash 计算地址的 Keccak-256 哈希值并返回其十六进制表示
func addressHash(address common.Address) string {
	hashBytes := crypto.Keccak256(address.Bytes())
	return common.Bytes2Hex(hashBytes)
}